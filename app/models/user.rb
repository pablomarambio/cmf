class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable#, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :haslocalpw, :comment, :threshold, :status, :main_picture, :username

  has_many :auth_providers, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :payments, :dependent => :destroy

  validates :threshold, :numericality => true, :if => :active_or_threshold?

  validates :email, :uniqueness => true, :presence => true, :format => {:with => /(?>(?:[0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+)[a-zA-Z]{2,9}/}, :if => :active_or_email?

  validates :comment, :presence => true, :if => :active_or_comment?

  validates :name, :presence => true, :if => :active_or_name?

  def active?
    status == 'active'
  end
  
  def active_or_threshold?
    status.include?('threshold') || active?
  end

  def active_or_name?
    status.include?('set_statement') || active?
  end
  
  def active_or_email?
    status.include?('set_email') || active?
  end
  
  def active_or_comment?
    status.include?('complete_profile') || active?
  end

  def add_auth_provider(h)
    raise "Invalid auth hash" unless h
    # if the user already has this provider linked
    existing_provider = self.auth_providers.first { |ap| ap.provider == h[:provider] }
    existing_provider.destroy if existing_provider
    self.auth_providers.create(
      :provider => provider,
      :uid => h[:id], 
      :uname => h[:real_name], 
      :uemail => h[:email],
      :username => h[:username],
      :image => h[:avatar],
      :profile_uri => h[:profile_uri])
    if self.auth_providers.count == 1
      # If this is this user's only auth provider, we set his username and avatar
      self.main_picture = h[:avatar]
      self.username = h[:username].downcase
      self.save!
    end
  end
  

end
