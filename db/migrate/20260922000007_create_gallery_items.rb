class CreateGalleryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :gallery_items do |t|
      t.string :title, null: false
      t.text :description
      t.string :alt_text
      t.string :media_type, null: false, default: "photo"
      t.string :category, null: false
      t.string :video_url
      t.boolean :featured, null: false, default: false
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :gallery_items, :category
    add_index :gallery_items, :media_type
    add_index :gallery_items, [ :active, :position ]
  end
end
