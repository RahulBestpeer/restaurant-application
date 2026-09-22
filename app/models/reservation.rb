class Reservation < ApplicationRecord
  STATUSES = %w[pending confirmed cancelled].freeze

  before_create :generate_confirmation_code

  validates :name,             presence: true
  validates :email,            presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :party_size,       presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :reservation_date, presence: true
  validates :reservation_time, presence: true,
                               format: { with: /\A([01]\d|2[0-3]):[0-5]\d\z/, message: "must be in HH:MM format" }
  validates :status,           inclusion: { in: STATUSES }

  validate :reservation_date_not_in_past

  private

  def generate_confirmation_code
    self.confirmation_code = SecureRandom.alphanumeric(8).upcase
  end

  def reservation_date_not_in_past
    return unless reservation_date.present?
    errors.add(:reservation_date, "must be today or in the future") if reservation_date < Date.current
  end
end
