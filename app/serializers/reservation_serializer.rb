class ReservationSerializer
  def self.render(reservation)
    {
      confirmation_code: reservation.confirmation_code,
      name: reservation.name,
      email: reservation.email,
      phone: reservation.phone,
      party_size: reservation.party_size,
      reservation_date: reservation.reservation_date,
      reservation_time: reservation.reservation_time,
      special_requests: reservation.special_requests,
      status: reservation.status,
      table_id: reservation.table_id,
      table: reservation.table ?
        TableSerializer.render(reservation.table) :
        nil,
      event_id: reservation.event_id,
      event: reservation.event ?
        EventSerializer.render(reservation.event) :
        nil,
      payments: reservation.payments.map {
        |payment|
        PaymentSerializer.render(payment)
      },
      total_paid: reservation.total_paid,
      deposit_amount: reservation.deposit_amount,
      total_amount: reservation.total_amount,
      notes: reservation.notes,
      created_at: reservation.created_at,
      end_time: reservation.end_time,
    }
  end
end
