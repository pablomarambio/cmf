class Message < ActiveRecord::Base
  attr_accessible :message, :requester_email, :user_id
  
  belongs_to :user
  has_one :answer
end
