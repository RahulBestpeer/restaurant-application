class AddFieldsToReservations < ActiveRecord::Migration[8.0]
  def change
    add_reference :reservations, :table, null: true, foreign_key: true
    add_reference :reservations, :event, null: true, foreign_key: true
    add_column :reservations, :notes, :text
    add_column :reservations, :deposit_amount, :decimal, precision: 8, scale: 2
    add_column :reservations, :total_amount, :decimal, precision: 8, scale: 2
  end
end
