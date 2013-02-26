class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :message_id
      t.string :text
      t.integer :utility, :default => 1
      t.integer :response_time, :default => 1

      t.timestamps
    end
  end
end
