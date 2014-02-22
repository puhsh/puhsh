class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :name, :first_name, :last_name, :avatar_url, :zipcode, :location_description, :latitude,
             :longitude, :home_city, :gender, :facebook_email, :contact_email, :posts_count, :posts_flagged_count,
             :app_invite, :star_count, :is_following, :other_avatar_urls

  has_one :home_city
  has_one :app_invite

  def is_following
    current_user ? current_user.following?(object) : false
  end
end
