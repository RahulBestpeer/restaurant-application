class CreateTables < ActiveRecord::Migration[8.0]
  def change
    create_table :tables do |t|
      t.string :number, null: false
      t.integer :capacity, null: false
      t.integer :min_capacity, default: 1, null: false
      t.string :location, null: false, default: "indoor"
      t.boolean :active, null: false, default: true
      t.text :notes

      t.timestamps
    end

    add_index :tables, :number, unique: true
  end
end
