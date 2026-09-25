class RenameStripePaymentFields < ActiveRecord::Migration[8.0]
  def change
    rename_column :payments,
                  :stripe_payment_intent_id,
                  :provider_transaction_id

    rename_column :payments,
                  :stripe_client_secret,
                  :provider_client_secret

    add_column :payments, :provider, :string

    remove_index :payments,
                 name: "index_payments_on_stripe_payment_intent_id",
                 if_exists: true
  end
end