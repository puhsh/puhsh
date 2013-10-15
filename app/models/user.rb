class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  devise :trackable, :omniauthable, omniauth_providers: [:facebook]

  def self.find_for_facebook_oauth(auth)
    auth = HashWithIndifferentAccess.new(auth)

    user = User.where(uid: auth[:uid]).first
    unless user
      self.create! do |user|
        user.uid = auth[:uid]
        user.name = auth[:info][:name]
        user.first_name = auth[:info][:first_name]
        user.last_name = auth[:info][:last_name]
        user.avatar_url = auth[:info][:image]
        user.location = auth[:info][:location]
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
end
