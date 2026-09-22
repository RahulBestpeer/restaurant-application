class CreateMenuCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_categories do |t|
      t.string :name_en
      t.string :slug
      t.string :category_type
      t.boolean :active
      t.integer :display_order
      t.integer :parent_id

      t.timestamps
    end
  end
end
