class AddRawToAuthProviders < ActiveRecord::Migration
  def change
    add_column :auth_providers, :raw, :text
  end
end
