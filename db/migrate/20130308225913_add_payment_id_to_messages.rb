class AddPaymentIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :payment_id, :integer
  end
end
