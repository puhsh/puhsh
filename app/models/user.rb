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
  has_one :access_token, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :wall_posts, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followers, class_name: 'Follow', foreign_key: 'followed_user_id', dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Callbacks
  before_save :set_home_city, :send_welcome_email
  after_commit :add_default_role, on: :create
  after_validation :geocode

  # Validations
  validates :uid, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :name, presence: true

  # Redis Attributes
  set :followed_city_ids
  set :post_ids_with_offers
  set :post_ids_with_questions
  set :user_ids_followed
  set :user_ids_following_self

  # Methods
  def self.find_for_facebook_oauth(auth)
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
  
  def nearby_cities(radius = 10)
    City.where(id: Zipcode.includes(:city).near(self, radius).map(&:city_id).uniq)
  end

  def admin?
    self.has_role?(:admin)
  end

  def cities_following
    followed_city_ids.members
  end

  def users_following
    user_ids_followed.members
  end

  def add_app_invite!
    AppInvite.create!(user: self, status: :inactive)
  end

  def following?(user)
    if user
      self.user_ids_followed.member?(user.id)
    else
      false
    end
  end

  def followed_by?(user)
    if user
      self.user_ids_following_self.member?(user.id)
    else
      false
    end
  end

  def friends?(user)
    following?(user) && followed_by?(user)
  end

  def users_following
    User.where(id: self.user_ids_followed.members)
  end

  def users_followers
    User.where(id: self.user_ids_following_self.members)
  end

  def recently_registered?
    self.contact_email && self.contact_email_changed? && self.contact_email_was.nil?
  end

  protected

  def add_default_role
    Rails.env.development? ? self.add_role(:admin) : self.add_role(:member)
  end

  def set_home_city
    if self.zipcode && (self.home_city.blank? || self.zipcode_changed?)
      zip = Zipcode.near(self, 5).first
      if zip
        self.home_city = zip.city
        self.home_city.follow!(self)
      end
    end
  end

  def send_welcome_email
    if self.recently_registered?
      Puhsh::Jobs::EmailJob.send_welcome_email({user_id: self.id})
    end
  end
end
