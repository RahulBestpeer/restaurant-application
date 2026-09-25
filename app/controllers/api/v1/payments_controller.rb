module Api
  module V1
    class PaymentsController < ApplicationController
      DEPOSIT_PERCENTAGE = 10.0

      def create
        reservation = Reservation.find_by!(
          confirmation_code: params[:confirmation_code].upcase
        )

        if reservation.status == "cancelled"
          return render(
            json: { error: "Cannot process payment for a cancelled reservation" },
            status: :unprocessable_entity
          )
        end

        if reservation.payments.where(status: %w[pending processing completed]).exists?
          return render(
            json: { error: "A payment already exists for this reservation" },
            status: :unprocessable_entity
          )
        end

        payment_type =
          params[:payment_type].presence_in(Payment::PAYMENT_TYPES) || "full"

        amount = resolve_amount(reservation, payment_type)

        if amount <= 0
          return render(
            json: { error: "Payment amount could not be determined. Contact the restaurant." },
            status: :unprocessable_entity
          )
        end

        payment = nil

        ActiveRecord::Base.transaction do
          # Lock the reservation row to serialize concurrent payment attempts
          reservation = Reservation.lock.find(reservation.id)

          # Re-check with lock held to close the TOCTOU window
          if reservation.payments.where(status: %w[pending processing completed]).exists?
            raise ActiveRecord::Rollback
          end

          payment = reservation.payments.create!(
            amount: amount,
            currency: "INR",
            payment_type: payment_type,
            status: "processing"
          )

          txn = payment.payment_transactions.create!(
            amount: amount,
            currency: "INR",
            status: "processing"
          )

          txn.complete!
          payment.complete!
          reservation.update!(status: "confirmed")
        end

        if payment.nil?
          return render(
            json: { error: "Payment already in progress or completed for this reservation" },
            status: :unprocessable_entity
          )
        end

        render(
          json: PaymentSerializer.render(
            Payment.includes(:payment_transactions).find(payment.id)
          ),
          status: :created
        )
      rescue ActiveRecord::RecordNotFound
        render(
          json: { error: "Reservation not found" },
          status: :not_found
        )
      rescue ActiveRecord::RecordInvalid => e
        render(
          json: { errors: e.record.errors.full_messages },
          status: :unprocessable_entity
        )
      rescue StandardError => e
        render(
          json: { error: e.message },
          status: :unprocessable_entity
        )
      end

      private

      def resolve_amount(reservation, payment_type)
        total_amount = reservation.total_amount

        return 0.to_d if total_amount.blank?

        case payment_type
        when "deposit"
          (total_amount.to_d * DEPOSIT_PERCENTAGE / 100).round(2)
        when "full"
          total_amount.to_d
        end
      end
    end
  end
end
