module Api
  module V1
    class PaymentsController < ApplicationController
      def create
        reservation = Reservation.find_by!(
          confirmation_code: params[:confirmation_code].upcase
        )

        payment_type =
          params[:payment_type].presence_in(Payment::PAYMENT_TYPES) || "full"

        provider = params[:provider].presence || "stripe"

        result = ::Payments::CreateService.new(
          reservation: reservation,
          payment_type: payment_type,
          provider: provider
        ).call

        render(
          json: {
            payment: PaymentSerializer.render(result[:payment]),
            transaction: PaymentTransactionSerializer.render(result[:transaction]),
            provider: result[:provider_data]
          },
          status: :created
        )
      rescue ActiveRecord::RecordNotFound
        render(
          json: { error: "Reservation not found" },
          status: :not_found
        )
      rescue ArgumentError => e
        render(
          json: { error: e.message },
          status: :unprocessable_entity
        )
      rescue ActiveRecord::RecordInvalid => e
        render(
          json: { errors: e.record.errors.full_messages },
          status: :unprocessable_entity
        )
      rescue StandardError => e
        Rails.logger.error(
          "Payment creation failed: #{e.class}: #{e.message}"
        )

        render(
          json: { error: "Unable to create payment" },
          status: :unprocessable_entity
        )
      end

      def show
        reservation = Reservation.find_by!(
          confirmation_code: params[:confirmation_code].upcase
        )

        result = ::Payments::ResumeService.new(
          reservation: reservation
        ).call

        render(
          json: {
            payment: PaymentSerializer.render(result[:payment]),
            transaction: PaymentTransactionSerializer.render(result[:transaction]),
            provider: result[:provider_data]
          }
        )
      rescue ActiveRecord::RecordNotFound
        render(
          json: { error: "Payment not found" },
          status: :not_found
        )
      rescue StandardError => e
        Rails.logger.error(
          "Payment retrieval failed: #{e.class}: #{e.message}"
        )

        render(
          json: { error: "Unable to retrieve payment" },
          status: :unprocessable_entity
        )
      end
    end
  end
end
