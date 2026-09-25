class Event < ApplicationRecord
  STATUSES = %w[
    upcoming
    active
    cancelled
    completed
  ].freeze

  EVENT_TYPES = %w[
    flamenco_show
    wine_tasting
    paella_class
    private_dining
    seasonal_menu
  ].freeze

  TIME_FORMAT = /\A([01]\d|2[0-3]):[0-5]\d\z/

  has_many :reservations, dependent: :nullify

  validates :name, presence: true

  validates :event_date, presence: true

  validates :start_time,
            presence: true,
            format: {
              with: TIME_FORMAT,
              message: "must be in HH:MM format"
            }

  validates :end_time,
            format: {
              with: TIME_FORMAT,
              message: "must be in HH:MM format"
            },
            allow_blank: true

  validates :max_capacity,
            presence: true,
            numericality: {
              greater_than: 0,
              only_integer: true
            }

  validates :price_per_person,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :status,
            inclusion: {
              in: STATUSES
            }

  validates :event_type,
            inclusion: {
              in: EVENT_TYPES
            },
            allow_blank: true

  scope :upcoming,
        -> {
          where(status: %w[upcoming active])
            .where(event_date: Date.current..)
        }

  scope :ordered,
        -> {
          order(:event_date, :start_time)
        }

  def spots_remaining
    max_capacity -
      reservations
        .where.not(status: "cancelled")
        .sum(:party_size)
  end

  def available?
    spots_remaining > 0 &&
      status.in?(%w[upcoming active]) &&
      event_date >= Date.current
  end

  def booking_open?
    return available? if booking_deadline.nil?

    available? &&
      Date.current <= booking_deadline
  end
end
