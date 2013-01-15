class AuthProvider < ActiveRecord::Base
  attr_accessible :provider, :uemail, :uid, :user_id

  belongs_to :user
end
