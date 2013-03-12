class Message < ActiveRecord::Base
  attr_accessible :message, :requester_email, :user_id
  
  belongs_to :user
  has_one :answer
  has_one :payment

  validates :message, :presence => true, :on => :create
  validates :requester_email, :presence => true, :on => :create
end
