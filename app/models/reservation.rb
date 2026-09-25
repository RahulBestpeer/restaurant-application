class Reservation < ApplicationRecord
  STATUSES = %w[pending confirmed cancelled].freeze
  TIME_FORMAT = /\A([01]\d|2[0-3]):[0-5]\d\z/

  belongs_to :table, optional: true
  belongs_to :event, optional: true

  has_many :payments, dependent: :destroy

  validates :table_id,
            presence: { message: "must be assigned for non-event reservations" },
            if: -> { event_id.blank? }

  before_create :generate_confirmation_code
  before_validation :set_event_datetime, if: -> { event_id.present? }
  before_create :calculate_total_amount

  validates :name, presence: true

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :party_size,
            presence: true,
            numericality: {
              greater_than: 0,
              only_integer: true
            }

  validates :end_time,
            format: {
              with: TIME_FORMAT,
              message: "must be in HH:MM format"
            },
            allow_blank: true

  validates :end_time,
            presence: true,
            if: -> { event_id.blank? }

  validate :end_time_after_start_time,
            if: -> {
              event_id.blank? &&
                reservation_time.present? &&
                end_time.present?
            }
  validates :reservation_date, presence: true

  validates :reservation_time,
            presence: true,
            format: {
              with: /\A([01]\d|2[0-3]):[0-5]\d\z/,
              message: "must be in HH:MM format"
            }

  validates :status, inclusion: { in: STATUSES }

  validate :reservation_date_not_in_past,
           if: -> { new_record? || will_save_change_to_reservation_date? }

  validate :restaurant_open_on_date,
           if: -> {
             reservation_date.present? && event_id.blank? &&
               (new_record? || will_save_change_to_reservation_date?)
           }

  validate :reservation_within_hours,
           if: -> {
             reservation_date.present? &&
               reservation_time.present? &&
               event_id.blank? &&
               (new_record? || will_save_change_to_reservation_date? || will_save_change_to_reservation_time?)
           }

  validate :table_available_for_slot,
            if: -> {
              table_id.present? &&
                (
                  new_record? ||
                  will_save_change_to_table_id? ||
                  will_save_change_to_reservation_date? ||
                  will_save_change_to_reservation_time? ||
                  will_save_change_to_end_time?
                )
            }

  validate :table_fits_party,
           if: -> {
             table.present? && party_size.present?
           }

  validate :event_bookable,
           if: -> {
             event_id.present? && new_record?
           }

  def cancel!
    update!(status: "cancelled")
  end

  def paid?
    payments.completed.exists?
  end

  def end_time_after_start_time
    start_minutes = Table.time_to_minutes(reservation_time)
    end_minutes   = Table.time_to_minutes(end_time)

    if end_minutes <= start_minutes
      errors.add(:end_time, "must be after reservation time")
    end
  end

  def total_paid
    payments.completed.sum(:amount)
  end

  private

  def generate_confirmation_code
    self.confirmation_code ||= SecureRandom.alphanumeric(8).upcase
  end

  def set_event_datetime
    return unless event

    self.reservation_date ||= event.event_date
    self.reservation_time ||= event.start_time
    self.end_time ||= event.end_time
  end

  def calculate_total_amount
    if event_id.present? && event.present? && party_size.present?
      self.total_amount = (event.price_per_person.to_d * party_size).round(2)
    elsif table.present? && reservation_time.present? && end_time.present?
      start_minutes    = Table.time_to_minutes(reservation_time)
      end_minutes      = Table.time_to_minutes(end_time)
      duration_minutes = end_minutes - start_minutes

      self.total_amount = (table.price.to_d * duration_minutes / 120).round(2)
    end
  end

  def reservation_date_not_in_past
    return unless reservation_date.present?

    if reservation_date < Date.current
      errors.add(
        :reservation_date,
        "must be today or in the future"
      )
    end
  end

  def restaurant_open_on_date
    info = BusinessHour.effective_for(reservation_date)

    return if info[:open]

    errors.add(
      :reservation_date,
      "the restaurant is closed — #{info[:reason]}"
    )
  end

  def reservation_within_hours
    info = BusinessHour.effective_for(reservation_date)

    return unless info[:open]

    unless BusinessHour.within_hours?(
      reservation_time,
      info[:open_time],
      info[:close_time]
    )
      errors.add(
        :reservation_time,
        "must be between #{info[:open_time]} and #{info[:close_time]}"
      )
    end
  end

  def table_available_for_slot
    return unless table && reservation_date && reservation_time && end_time

    requested_start = Table.time_to_minutes(reservation_time)
    requested_end   = Table.time_to_minutes(end_time)

    conflict = Reservation
      .where(table_id: table_id, reservation_date: reservation_date)
      .where.not(status: "cancelled")
      .where.not(id: id)
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
      .exists?

    if conflict
      errors.add(:table, "is not available for the selected date and time")
    end
  end

  def table_fits_party
    if party_size > table.capacity
      errors.add(
        :party_size,
        "exceeds table capacity of #{table.capacity}"
      )
    end
  end

  def event_bookable
    unless event.booking_open?
      errors.add(
        :event,
        "is not available for booking"
      )
    end
  end
end
