class AuthProvider < ActiveRecord::Base
  attr_accessible :provider, :uemail, :uid, :user_id, :uname, :image, :username, :profile_uri	, :raw

  belongs_to :user
end
