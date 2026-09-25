class RemoveProviderFieldsFromPayments < ActiveRecord::Migration[8.0]
  def change
    remove_column :payments, :provider, :string
    remove_column :payments, :provider_transaction_id, :string
    remove_column :payments, :provider_client_secret, :string
    remove_column :payments, :provider_refund_id, :string
  end
end
