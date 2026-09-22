class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.string  :name,              null: false
      t.string  :email,             null: false
      t.string  :phone
      t.integer :party_size,        null: false
      t.date    :reservation_date,  null: false
      t.string  :reservation_time,  null: false
      t.text    :special_requests
      t.string  :status,            null: false, default: "pending"
      t.string  :confirmation_code, null: false

      t.timestamps
    end

    add_index :reservations, :confirmation_code, unique: true
    add_index :reservations, [ :reservation_date, :reservation_time ]
  end
end
