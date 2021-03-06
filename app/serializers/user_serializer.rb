class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :name, :first_name, :last_name, :avatar_url, :zipcode, :location_description, :latitude,
             :longitude, :home_city, :gender, :facebook_email, :contact_email, :posts_count, :posts_flagged_count,
             :app_invite, :star_count, :is_following, :avatar_urls, :unread_notifications_count, :confirmed_at

  has_one :home_city, serializer: HomeCitySerializer
  has_one :app_invite

  def is_following
    scope.try { |x| x.following?(object) }
  end

  def avatar_urls
    object.other_avatar_urls
  end
end
