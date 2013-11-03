class User < ActiveRecord::Base
  INVITES_ENABLED = Rails.env.development? ? false : true

  attr_accessible :uid, :authentication_token, :home_city, :first_name, :last_name, :email, :name, :zipcode, :location_description, :contact_email
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
  has_one :app_invite
  has_one :access_token
  has_many :devices

  # Callbacks
  after_create :add_default_role, :set_home_city, :add_app_invite
  after_validation :geocode

  # Validations
  validates :uid, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :name, presence: true

  # Methods
  def self.find_for_facebook_oauth(auth)
    auth = HashWithIndifferentAccess.new(auth)

    user = User.where(uid: auth[:id]).first
    if user.blank?
      self.create! do |user|
        user.uid = auth[:id]
        user.name = auth[:name]
        user.first_name = auth[:first_name]
        user.last_name = auth[:last_name]
        user.avatar_url = "http://graph.facebook.com/#{auth[:id]}/picture?type=square"
        user.gender = auth[:gender]
        user.facebook_email = auth[:email]
      end
    else
      if user.avatar_url != "http://graph.facebook.com/#{auth[:id]}/picture?type=square"
        user.avatar_url = "http://graph.facebook.com/#{auth[:id]}/picture?type=square"
        user.save
      end
      user
    end
  end

  def generate_access_token!
    self.access_token.nil? ? AccessToken.create!(user: self) : self.access_token.touch
  end

  protected

  def add_default_role
    Rails.env.development? ? self.add_role(:admin) : self.add_role(:member)
  end

  def set_home_city
    self.update_attributes(home_city: City.near(self, 5).first)
  end

  def add_app_invite
    AppInvite.create!(user: self, status: :inactive) if INVITES_ENABLED
  end

end

