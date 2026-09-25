class BackfillEventReservationTotalAmounts < ActiveRecord::Migration[8.0]
  def up
    Reservation
      .joins(:event)
      .where(total_amount: nil)
      .where.not(event_id: nil)
      .find_each do |reservation|
        total = (reservation.event.price_per_person.to_d * reservation.party_size).round(2)
        reservation.update_column(:total_amount, total)
      end
  end

  def down; end
end
