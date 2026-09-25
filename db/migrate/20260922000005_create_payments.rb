class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :reservation, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :currency, null: false, default: "INR"
      t.string :status, null: false, default: "pending"
      t.string :payment_type, null: false, default: "full"
      t.string :provider
      t.string :provider_transaction_id
      t.string :provider_client_secret
      t.datetime :paid_at
      t.text :notes

      t.timestamps
    end

    add_index :payments, :provider_transaction_id, unique: true,
              where: "provider_transaction_id IS NOT NULL"
    add_index :payments, :status
  end
end
