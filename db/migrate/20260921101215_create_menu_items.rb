class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :name_en
      t.text :description_en
      t.string :alt_text_en
      t.decimal :price
      t.boolean :available
      t.boolean :featured
      t.integer :display_order
      t.references :menu_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
