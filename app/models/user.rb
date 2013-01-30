class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable#, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :haslocalpw, :comment, :threshold, :status

  has_many :auth_providers, :dependent => :destroy

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
    status.include?('set_statement') || active?
  end
  

end
