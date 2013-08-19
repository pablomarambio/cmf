class AddLocalPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :local_picture, :string
  end
end
