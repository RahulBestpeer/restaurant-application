class AddRefundFieldsToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :provider_refund_id, :string
    add_column :payments, :refunded_amount, :decimal, precision: 10, scale: 2
    add_column :payments, :refunded_at, :datetime
  end
end
