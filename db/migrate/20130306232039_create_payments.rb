class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :amount
      t.integer :random, :default => rand(99999)
      t.string :status, :default => "pending"
      t.integer :user_id

      t.timestamps
    end
  end
end
