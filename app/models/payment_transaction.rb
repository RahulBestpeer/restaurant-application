class PaymentTransaction < ApplicationRecord
  STATUSES = %w[pending processing completed failed refunded].freeze

  belongs_to :payment

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  validates :currency, presence: true

  validates :status, inclusion: { in: STATUSES }

  def complete!
    update!(status: "completed", completed_at: Time.current)
  end

  def fail!
    update!(status: "failed", failed_at: Time.current)
  end
end
