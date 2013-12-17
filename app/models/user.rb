class User < ActiveRecord::Base
  include StarRewardable
  include BadgeRewardable
  include Redis::Objects

  INVITES_ENABLED = Rails.env.development? ? false : true
  ALPHA_ENABLED = Rails.env.development? ? false : true

  attr_accessible :uid, :authentication_token, :home_city, :first_name, :last_name, :email, :name, :zipcode, :location_description, :contact_email, :star_count
  devise :trackable, :omniauthable, omniauth_providers: [:facebook]
  rolify
  geocoded_by :zipcode

  # Relations
  has_many :posts
  has_many :followed_cities, dependent: :destroy
  has_many :cities, through: :followed_cities
  belongs_to :home_city, class_name: 'City', foreign_key: 'city_id'
  has_many :offers, dependent: :destroy
  has_many :flagged_posts, dependent: :destroy
  has_one :app_invite, dependent: :destroy
  has_one :android_app_invite, dependent: :destroy
  has_one :access_token, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges, dependent: :destroy
  has_many :invites, dependent: :destroy

  # Callbacks
  after_create :add_default_role, :set_home_city
  after_validation :geocode

  # Validations
  validates :uid, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :name, presence: true

  # Redis Attributes
  set :followed_city_ids
  set :post_ids_with_offers
  value :mobile_device_type

  # Methods
  def self.find_for_facebook_oauth(auth, device_type = nil)
    auth = HashWithIndifferentAccess.new(auth)

    user = User.where(uid: auth[:id]).first
    if user.blank?
      user = self.create! do |user|
        user.uid = auth[:id]
        user.name = auth[:name]
        user.first_name = auth[:first_name]
        user.last_name = auth[:last_name]
        user.avatar_url = "http://graph.facebook.com/#{auth[:id]}/picture?type=square"
        user.gender = auth[:gender]
        user.facebook_email = auth[:email]
      end
      
      # Store the mobile device type in redis so we know what queue to add them to
      if user && device_type
        user.mobile_device_type.value = device_type
      end

      # Add the app invite
      user.add_app_invite!
      user
    else
      user.avatar_url = "http://graph.facebook.com/#{auth[:id]}/picture?type=square"
      user.save
      user
    end
  end

  def generate_access_token!
    if self.access_token.nil?
      AccessToken.create!(user: self)
    else
      self.access_token.save!
    end
  end
  
  def nearby_cities(radius = 20)
    Zipcode.includes(:city).near(self, radius).map(&:city).uniq
  end

  def admin?
    self.has_role?(:admin)
  end

  def cities_following
    followed_city_ids.members
  end

  def add_app_invite!
    case self.mobile_device_type.value
    when 'ios'
      AppInvite.create!(user: self, status: :inactive)
    when 'android'
      AndroidAppInvite.create!(user: self, status: :inactive)
    else
      nil
    end
  end

  protected

  def add_default_role
    Rails.env.development? ? self.add_role(:admin) : self.add_role(:member)
  end

  def set_home_city
    zipcode = Zipcode.near(self, 5).first
    if zipcode
      self.update_attributes(home_city: zipcode.city)
      self.reload.home_city.follow!(self)
    end
  end
end
