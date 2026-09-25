class AddEndTimeToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :end_time, :string
  end
end
