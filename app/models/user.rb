class User < ActiveRecord::Base
  attr_accessible :uid, :authentication_token
  devise :trackable, :omniauthable, :timeoutable, :token_authenticatable, omniauth_providers: [:facebook]
  rolify
  geocoded_by :zipcode

  # Relations
  has_many :posts
  has_many :user_cities, dependent: :destroy
  has_many :cities, through: :user_cities
  has_many :offers, dependent: :destroy
  has_many :flagged_posts, dependent: :destroy
  has_one :app_invite

  # Callbacks
  after_create :add_default_role
  after_validation :geocode

  # Validations
  validates :uid, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :name, presence: true
  validates :facebook_email, presence: true
  validates :zipcode, presence: true, on: :update

  # Methods
  def self.find_for_facebook_oauth(auth)
    auth = HashWithIndifferentAccess.new(auth)
    return unless auth[:verified]

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
        user.avatar_url = "http://graph.facebook.com/#{auth[:id]}/picture?type=square",
        user.save
      end
      user
    end
  end

  def generate_access_token!
    self.update_attributes(authentication_token: SecureRandom.hex)
  end

  protected

  def add_default_role
    Rails.env.development? ? self.add_role(:admin) : self.add_role(:member)
  end
end

