class Payment < ActiveRecord::Base
  attr_accessible :amount, :random, :status, :user_id
  belongs_to :user
end
