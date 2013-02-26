class Answer < ActiveRecord::Base
  attr_accessible :message_id, :response_time, :text, :utility
  belongs_to :message

end
