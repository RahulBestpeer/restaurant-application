class AddLocalizationFieldsToMenuCategoriesAndMenuItems < ActiveRecord::Migration[8.0]
  def change
    add_column :menu_categories, :name_es, :string

    add_column :menu_items, :name_es, :string
    add_column :menu_items, :description_es, :text
    add_column :menu_items, :alt_text_es, :string
    add_column :menu_items, :dietary_flags, :jsonb
  end
end