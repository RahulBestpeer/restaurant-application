class EventSerializer
  def self.render(event, detailed: false)
    data = {
      id:               event.id,
      name:             event.name,
      event_date:       event.event_date,
      start_time:       event.start_time,
      end_time:         event.end_time,
      max_capacity:     event.max_capacity,
      spots_remaining:  event.spots_remaining,
      price_per_person: event.price_per_person,
      status:           event.status,
      event_type:       event.event_type,
      available:        event.available?,
      booking_deadline: event.booking_deadline
    }

    data[:description] = event.description if detailed
    data
  end
end
