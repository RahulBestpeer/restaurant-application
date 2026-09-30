class PaymentTransactionSerializer
  def self.render(transaction)
    {
      id: transaction.id,
      payment_id: transaction.payment_id,
      amount: transaction.amount,
      currency: transaction.currency,
      status: transaction.status,
      transaction_type: transaction.transaction_type,
      provider: transaction.provider,
      provider_transaction_id: transaction.provider_transaction_id,
      completed_at: transaction.completed_at,
      failed_at: transaction.failed_at,
      created_at: transaction.created_at
    }
  end
end
