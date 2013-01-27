class AddUnameToAuthProviders < ActiveRecord::Migration
  def change
    add_column :auth_providers, :uname, :string
  end
end
