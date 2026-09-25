class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.date :event_date, null: false
      t.string :start_time, null: false
      t.string :end_time
      t.integer :max_capacity, null: false
      t.decimal :price_per_person, precision: 8, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "upcoming"
      t.string :event_type
      t.date :booking_deadline

      t.timestamps
    end

    add_index :events, :event_date
    add_index :events, :status
  end
end
