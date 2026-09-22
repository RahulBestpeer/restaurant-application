class ReservationSerializer
  def self.render(reservation)
    {
      confirmation_code: reservation.confirmation_code,
      name:              reservation.name,
      phone:             reservation.phone,
      party_size:        reservation.party_size,
      reservation_date:  reservation.reservation_date,
      reservation_time:  reservation.reservation_time,
      special_requests:  reservation.special_requests,
      status:            reservation.status,
      created_at:        reservation.created_at
    }
  end
end
