class AddProviderToPaymentTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_transactions, :transaction_type, :string, null: false, default: "payment"
    add_column :payment_transactions, :provider, :string, null: false, default: "stripe"
    add_column :payment_transactions, :provider_transaction_id, :string

    add_index :payment_transactions, :provider
    add_index :payment_transactions, :transaction_type
    add_index :payment_transactions,
              [:provider, :provider_transaction_id],
              unique: true,
              name: "index_payment_transactions_on_provider_and_provider_txn_id"
  end
end