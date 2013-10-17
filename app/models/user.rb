class User < ActiveRecord::Base
  attr_accessible :uid
  devise :trackable, :omniauthable, omniauth_providers: [:facebook]
  rolify
  geocoded_by :address

  # Callbacks
  after_create :add_default_role
  after_validation :geocode

  def self.find_for_facebook_oauth(auth)
    auth = HashWithIndifferentAccess.new(auth)

    user = User.where(uid: auth[:uid]).first
    if user.blank?
      self.create! do |user|
        user.uid = auth[:uid]
        user.name = auth[:info][:name]
        user.first_name = auth[:info][:first_name]
        user.last_name = auth[:info][:last_name]
        user.avatar_url = auth[:info][:image]
        location = auth[:info][:location]
        if location
          city,state = location.split(',')
          user.city = city
          user.state = state
        end
        user.gender = auth[:extra][:raw_info][:gender] if auth[:extra][:raw_info].present?
        user.facebook_email = auth[:info][:email]
      end
    else
      if user.avatar_url != auth['info']['image']
        user.avatar_url = auth[:info][:image]
        user.save
      end
      user
    end
  end

  def address
    "#{city}, #{state}, US"
  end

  protected

  def add_default_role
    Rails.env.development? ? self.add_role(:admin) : self.add_role(:member)
  end
end

