# coding: utf-8
class AuthProvider < ActiveRecord::Base
  attr_accessible :provider, :uemail, :uid, :user_id, :uname, :image, :username, :profile_uri	, :raw

  belongs_to :user

  def safe_username
  	ActiveSupport::Inflector.transliterate username.downcase.gsub(/\s/,"_")
  end
end