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

  validates :threshold, :numericality => true, :if => :should_check_threshold?
  validates :email, :uniqueness => true, :presence => true, :format => {:with => /(?>(?:[0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+)[a-zA-Z]{2,9}/}, :if => :should_check_email?
  validates :comment, :presence => true, :if => :should_check_comment?
  validates :name, :presence => true, :if => :should_check_email?
  validates :bank_account, :presence => true, :if => :should_check_bank_account?

  state_machine :status, :initial => :idle do
    event :set_threshold do
      transition :idle => :signing_up
    end

    event :complete_profile do
      transition :signing_up => :signed_up
    end

    event :set_bank_account do
      transition :registered => :ready
    end

    state :idle do
      def should_check_email?; false; end
      def should_check_comment?; false; end
      def should_check_name?; false; end
      def should_check_threshold?; false; end
      def should_check_bank_account?; false; end
    end

    state :signing_up do
      def should_check_email?; false; end
      def should_check_comment?; false; end
      def should_check_name?; false; end
      def should_check_threshold?; true; end
      def should_check_bank_account?; false; end
    end

    state :signed_up do
      def should_check_email?; true; end
      def should_check_comment?; true; end
      def should_check_name?; true; end
      def should_check_threshold?; true; end
      def should_check_bank_account?; false; end
    end

    state :ready do
      def should_check_email?; true; end
      def should_check_comment?; true; end
      def should_check_name?; true; end
      def should_check_threshold?; true; end
      def should_check_bank_account?; true; end
    end
  end

  def can_move_to_signed_up?
    email? and name? and username? and comment?
  end

  def add_auth_provider(h)
    raise "Invalid auth hash" unless h
    # if the user already has this provider linked
    existing_provider = self.auth_providers.where( 'provider = ?', h[:provider_name] ).first
    existing_provider.destroy if existing_provider
    self.auth_providers.create(
      :provider => h[:provider_name],
      :uid => h[:id], 
      :uname => h[:real_name], 
      :uemail => h[:email],
      :username => h[:username],
      :image => h[:avatar],
      :profile_uri => h[:profile_uri],
      :raw => h[:raw])
    if self.auth_providers.count == 1
      # If this is this user's only auth provider, we set his username and avatar
      self.set_main_picture h[:provider_name]
      self.set_name h[:provider_name]
      self.username = h[:username].downcase
      self.save!
    end
  end

  def set_main_picture(provider_name)
    provider = get_provider provider_name
    self.main_picture = provider.image
  end

  # Returns the pictures from the auth providers the user isn't using
  def alternative_pictures
    auth_providers.map do |ap|
      if main_picture == ap.image
        nil
      else
        { provider: ap.provider, image: ap.image }
      end 
    end.compact
  end

  def set_name(provider_name)
    provider = get_provider provider_name
    self.provider_name = provider.provider
    self.name = provider.uname
    self.username = provider.safe_username
  end

  # Returns the names from all auth providers
  def alternative_names
    auth_providers.map do |ap|
      { provider: ap.provider, name: "#{ap.uname} (#{ap.provider})" }
    end
  end

  def to_s
    self.name || "User #{self.id}"
  end

  private
  def get_provider provider_name
    provider = self.auth_providers.where('provider = ?', provider_name).first
    raise "No provider called #{provider_name} for #{self.to_s}" unless provider
    provider
  end

end
