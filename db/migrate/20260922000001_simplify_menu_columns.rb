class SimplifyMenuColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :menu_categories, :name_en, :name
    remove_column :menu_categories, :name_es, :string

    rename_column :menu_items, :name_en, :name
    rename_column :menu_items, :description_en, :description
    rename_column :menu_items, :alt_text_en, :alt_text
    remove_column :menu_items, :name_es, :string
    remove_column :menu_items, :description_es, :text
    remove_column :menu_items, :alt_text_es, :string
  end
end
