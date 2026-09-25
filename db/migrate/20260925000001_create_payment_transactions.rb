class CreatePaymentTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_transactions do |t|
      t.references :payment, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :currency, null: false, default: "INR"
      t.string :status, null: false, default: "pending"
      t.datetime :completed_at
      t.datetime :failed_at
      t.text :notes

      t.timestamps
    end

    add_index :payment_transactions, :status
  end
end
