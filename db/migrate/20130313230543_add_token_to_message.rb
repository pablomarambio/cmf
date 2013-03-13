class AddTokenToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :secure_token, :string, :default => SecureRandom.hex(8), :unique => true
  end
end
