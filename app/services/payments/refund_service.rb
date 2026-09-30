module Payments
  class RefundService
    def initialize(payment:, amount:)
      @payment = payment
      @amount = amount.to_d
    end

    def call
      validate!

      transaction = @payment.payment_transactions
        .where(transaction_type: "payment")
        .where(status: "completed")
        .order(created_at: :desc)
        .first

      raise ArgumentError, "Completed payment transaction not found" unless transaction

      provider = PaymentProviders::Registry.for(transaction.provider)

      result = provider.refund(
        transaction,
        amount: @amount
      )

      refund_transaction = @payment.payment_transactions.create!(
        amount: @amount,
        currency: @payment.currency,
        transaction_type: "refund",
        provider: transaction.provider,
        provider_transaction_id: result[:provider_transaction_id],
        status: "refunded",
        completed_at: Time.current
      )

      @payment.update!(
        status: "refunded",
        refunded_amount: @amount,
        refunded_at: Time.current
      )

      refund_transaction
    end

    private

    def validate!
      raise ArgumentError, "Payment must be completed" unless @payment.completed?

      if @amount <= 0
        raise ArgumentError, "Refund amount must be greater than zero"
      end

      if @amount > @payment.amount
        raise ArgumentError, "Refund amount cannot exceed payment amount"
      end
    end
  end
end
