class BusinessHour < ApplicationRecord
  TIME_FORMAT = /\A([01]\d|2[0-3]):[0-5]\d\z/
  DAY_NAMES   = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze

  validates :open_time,  format: { with: TIME_FORMAT, message: "must be HH:MM" }, allow_blank: true
  validates :close_time, format: { with: TIME_FORMAT, message: "must be HH:MM" }, allow_blank: true

  validate :has_day_or_date
  validate :times_present_when_open

  scope :weekly,    -> { where(specific_date: nil).order(:day_of_week) }
  scope :upcoming_overrides, -> { where(specific_date: Date.current..).order(:specific_date) }

  def weekly?
    specific_date.nil?
  end

  def day_name
    weekly? ? DAY_NAMES[day_of_week] : specific_date.strftime("%A, %-d %B %Y")
  end

  def self.effective_for(date)
    date = date.is_a?(Date) ? date : Date.parse(date.to_s)

    override = find_by(specific_date: date)
    if override
      return build_info(override, override: true)
    end

    weekly = find_by(day_of_week: date.wday, specific_date: nil)
    return { open: false, reason: "No schedule configured", override: false } unless weekly

    build_info(weekly, override: false)
  end

  def self.within_hours?(time_str, open_str, close_str)
    t = minutes(time_str)
    o = minutes(open_str)
    c = minutes(close_str)
    c < o ? (t >= o || t <= c) : (t >= o && t <= c)
  end

  def self.minutes(time_str)
    h, m = time_str.split(":").map(&:to_i)
    h * 60 + m
  end

  private_class_method def self.build_info(record, override:)
    if record.closed?
      { open: false, reason: record.reason.presence || "Closed", override: override }
    else
      { open: true, open_time: record.open_time, close_time: record.close_time,
        reason: record.reason, override: override }
    end
  end

  private

  def has_day_or_date
    if day_of_week.nil? && specific_date.nil?
      errors.add(:base, "must have either a day of week or a specific date")
    elsif day_of_week.present? && specific_date.present?
      errors.add(:base, "cannot have both a day of week and a specific date")
    end
    if day_of_week.present? && !day_of_week.between?(0, 6)
      errors.add(:day_of_week, "must be between 0 (Sunday) and 6 (Saturday)")
    end
  end

  def times_present_when_open
    return if closed?
    errors.add(:open_time,  "is required when not closed") if open_time.blank?
    errors.add(:close_time, "is required when not closed") if close_time.blank?
  end
end
