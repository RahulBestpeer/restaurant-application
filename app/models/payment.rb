class Payment < ApplicationRecord
  STATUSES = %w[
    pending
    processing
    completed
    failed
    refunded
  ].freeze

  PAYMENT_TYPES = %w[
    deposit
    full
  ].freeze

  belongs_to :reservation
  has_many :payment_transactions, dependent: :destroy

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  validates :currency, presence: true

  validates :status, inclusion: { in: STATUSES }

  validates :payment_type, inclusion: { in: PAYMENT_TYPES }

  scope :completed, -> { where(status: "completed") }
  scope :pending,   -> { where(status: "pending") }

  def completed?
    status == "completed"
  end

  def complete!
    return if completed?

    update!(status: "completed", paid_at: Time.current)
  end

  def refund!(refund_amount)
    raise ArgumentError, "Only completed payments can be refunded" unless completed?
    raise ArgumentError, "Refund amount must be greater than zero" if refund_amount <= 0
    raise ArgumentError, "Refund amount cannot exceed payment amount" if refund_amount > amount

    transaction do
      payment_transactions.create!(
        amount: refund_amount,
        currency: currency,
        status: "refunded",
        completed_at: Time.current
      )
      update!(
        status: "refunded",
        refunded_amount: refund_amount,
        refunded_at: Time.current
      )
    end
  end
end
