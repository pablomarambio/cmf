class AddImageToAuthProviders < ActiveRecord::Migration
  def self.up
    add_column :auth_providers, :image, :string
  end

  def self.down
    remove_column :auth_providers, :image
  end

end
