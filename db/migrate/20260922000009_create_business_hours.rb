class CreateBusinessHours < ActiveRecord::Migration[8.0]
  def change
    create_table :business_hours do |t|
      # For regular weekly rows: 0=Sunday, 1=Monday … 6=Saturday (Ruby Date#wday)
      # Null when this row is a specific-date override.
      t.integer :day_of_week

      # For date-specific overrides (holidays, private events, closures).
      # Null for regular weekly rows.
      t.date :specific_date

      t.string :open_time   # HH:MM, null when closed: true
      t.string :close_time  # HH:MM, null when closed: true
      t.boolean :closed, null: false, default: false
      t.string :reason      # e.g. "Christmas Day", "Private Event", "Renovation"
      t.string :notes

      t.timestamps
    end

    # One row per weekday (regular schedule)
    add_index :business_hours, :day_of_week, unique: true,
              where: "specific_date IS NULL"

    # One row per specific date (holiday / override)
    add_index :business_hours, :specific_date, unique: true,
              where: "specific_date IS NOT NULL"
  end
end
