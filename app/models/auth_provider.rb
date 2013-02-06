class AuthProvider < ActiveRecord::Base
  attr_accessible :provider, :uemail, :uid, :user_id, :uname, :image

  belongs_to :user
end
