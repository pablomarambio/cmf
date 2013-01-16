class AddShowToAuthProviders < ActiveRecord::Migration
  def change
  	# Wether to show a link or not to the user's profile in the social netowrk
  	add_column :auth_providers, :display, :boolean
  end
end
