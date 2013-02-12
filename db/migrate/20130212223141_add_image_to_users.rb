class AddImageToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :main_picture, :string
  end

  def self.down
    remove_column :users, :main_picture
  end
end
