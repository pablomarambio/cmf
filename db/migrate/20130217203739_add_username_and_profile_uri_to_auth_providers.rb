class AddUsernameAndProfileUriToAuthProviders < ActiveRecord::Migration
  def change
    add_column :auth_providers, :username, :string
    add_column :auth_providers, :profile_uri, :string
  end
end
