class CreateTeamMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :team_members do |t|
      t.string :name, null: false
      t.string :role, null: false
      t.text :bio
      t.string :instagram_url
      t.boolean :featured, null: false, default: false
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :team_members, [ :active, :position ]
  end
end
