module Payments
  class CreateService
    DEPOSIT_PERCENTAGE = 10.0

    def initialize(reservation:, payment_type:, provider: "stripe")
      @reservation = reservation
      @payment_type = payment_type
      @provider_name = provider
    end

    def call
      validate_reservation!

      amount = resolve_amount

      if amount <= 0
        raise ArgumentError,
              "Payment amount could not be determined. Contact the restaurant."
      end

      payment = nil
      transaction = nil

      ActiveRecord::Base.transaction do
        reservation = Reservation.lock.find(@reservation.id)

        if reservation.payments.where(
          status: %w[pending processing completed]
        ).exists?
          raise ArgumentError,
                "A payment already exists for this reservation"
        end

        payment = reservation.payments.create!(
          amount: amount,
          currency: "INR",
          payment_type: @payment_type,
          status: "processing"
        )

        transaction = payment.payment_transactions.create!(
          amount: amount,
          currency: "INR",
          transaction_type: "payment",
          provider: @provider_name,
          status: "processing"
        )
      end

      provider = PaymentProviders::Registry.for(@provider_name)

      result = provider.create_payment(transaction)

      transaction.update!(
        provider_transaction_id: result[:provider_transaction_id]
      )

      {
        payment: payment.reload,
        transaction: transaction.reload,
        provider_data: result
      }
    end

    private

    def validate_reservation!
      if @reservation.status == "cancelled"
        raise ArgumentError,
              "Cannot process payment for a cancelled reservation"
      end

      unless Payment::PAYMENT_TYPES.include?(@payment_type)
        raise ArgumentError, "Invalid payment type"
      end
    end

    def resolve_amount
      total_amount = @reservation.total_amount

      return 0.to_d if total_amount.blank?

      case @payment_type
      when "deposit"
        (total_amount.to_d * DEPOSIT_PERCENTAGE / 100).round(2)
      when "full"
        total_amount.to_d
      end
    end
  end
end
