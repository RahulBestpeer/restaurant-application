class BusinessHourSerializer
  def self.render(bh)
    {
      id:            bh.id,
      day_of_week:   bh.day_of_week,
      specific_date: bh.specific_date,
      day_name:      bh.day_name,
      open:          !bh.closed?,
      open_time:     bh.open_time,
      close_time:    bh.close_time,
      reason:        bh.reason,
      notes:         bh.notes
    }
  end
end
