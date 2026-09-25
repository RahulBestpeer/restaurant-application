class PaymentSerializer
  def self.render(payment)
    {
      id: payment.id,
      reservation_id: payment.reservation_id,
      amount: payment.amount,
      currency: payment.currency,
      status: payment.status,
      payment_type: payment.payment_type,
      paid_at: payment.paid_at,
      refunded_amount: payment.refunded_amount,
      refunded_at: payment.refunded_at,
      transactions: payment.payment_transactions.map { |t| PaymentTransactionSerializer.render(t) },
      created_at: payment.created_at
    }
  end
end
