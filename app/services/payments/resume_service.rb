module Payments
  class ResumeService
    def initialize(reservation:)
      @reservation = reservation
    end

    def call
      payment = @reservation.payments
        .order(created_at: :desc)
        .first

      raise ActiveRecord::RecordNotFound, "Payment not found" unless payment

      transaction = payment.payment_transactions
        .where(transaction_type: "payment")
        .order(created_at: :desc)
        .first

      raise ActiveRecord::RecordNotFound,
            "Payment transaction not found" unless transaction

      provider = PaymentProviders::Registry.for(transaction.provider)

      provider_data = provider.retrieve_payment(transaction)

      {
        payment: payment,
        transaction: transaction,
        provider_data: provider_data
      }
    end
  end
end
