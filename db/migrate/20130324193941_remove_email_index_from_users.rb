class RemoveEmailIndexFromUsers < ActiveRecord::Migration
  def up
  	remove_index :users, :column => :email
  end

  def down
  	add_index :users, :column => :email, :name => "index_users_on_email", :unique => true
  end
end
