class AuthProvider < ActiveRecord::Base
  attr_accessible :provider, :uemail, :uid, :user_id, :uname

  belongs_to :user
end
