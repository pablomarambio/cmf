class CreateAuthProviders < ActiveRecord::Migration
  def change
    create_table :auth_providers do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :uemail

      t.timestamps
    end
  end
end
