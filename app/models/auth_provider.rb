class AuthProvider < ActiveRecord::Base
  attr_accessible :provider, :uemail, :uid, :user_id, :uname, :image, :username, :profile_uri	

  belongs_to :user
end
