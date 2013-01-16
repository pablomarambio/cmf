class AddThresholdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :threshold, :float
  end
end
