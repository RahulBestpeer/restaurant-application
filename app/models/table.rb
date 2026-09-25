class Table < ApplicationRecord
  LOCATIONS = %w[
    indoor
    outdoor
    bar
    patio
    private
  ].freeze

  has_many :reservations, dependent: :nullify

  validates :number,
            presence: true,
            uniqueness: true

  validates :capacity,
            presence: true,
            numericality: {
              greater_than: 0,
              only_integer: true
            }

  validates :price,
            numericality: {
              greater_than_or_equal_to: 0
            }

  validates :min_capacity,
            numericality: {
              greater_than: 0,
              only_integer: true
            }

  validates :location,
            inclusion: {
              in: LOCATIONS
            }

  validate :min_capacity_cannot_exceed_capacity

  scope :active, -> { where(active: true) }

  scope :ordered, -> { order(:capacity, :number) }

  def self.available_for(date, start_time, end_time, party_size)
    requested_start = time_to_minutes(start_time)
    requested_end   = time_to_minutes(end_time)

    reserved_table_ids = Reservation
      .where(reservation_date: date)
      .where.not(status: "cancelled")
      .where.not(table_id: nil)
      .where(
        <<~SQL,
          (
            split_part(reservation_time, ':', 1)::integer * 60 +
            split_part(reservation_time, ':', 2)::integer
          ) < ?
          AND
          (
            split_part(end_time, ':', 1)::integer * 60 +
            split_part(end_time, ':', 2)::integer
          ) > ?
        SQL
        requested_end,
        requested_start
      )
      .pluck(:table_id)

    active
      .where("capacity >= ?", party_size)
      .where.not(id: reserved_table_ids)
      .order(:capacity, :number)
  end

  def self.time_to_minutes(time_str)
    return 0 unless time_str&.match?(
      /\A([01]\d|2[0-3]):[0-5]\d\z/
    )

    hours, minutes = time_str.split(":").map(&:to_i)

    hours * 60 + minutes
  end

  def booking_price(start_time, end_time)
    start_minutes = self.class.time_to_minutes(start_time)
    end_minutes   = self.class.time_to_minutes(end_time)

    duration_minutes = end_minutes - start_minutes

    (price.to_d * duration_minutes / 120).round(2)
  end

  private

  def min_capacity_cannot_exceed_capacity
    return unless capacity.present? && min_capacity.present?

    if min_capacity > capacity
      errors.add(
        :min_capacity,
        "cannot be greater than table capacity"
      )
    end
  end
end
