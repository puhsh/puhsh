class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :name, :first_name, :last_name, :avatar_url, :zipcode, :location_description, :latitude,
             :longitude, :home_city, :gender, :facebook_email, :contact_email, :posts_count, :posts_flagged_count,
             :app_invite, :star_count

  has_one :home_city
  has_one :app_invite
  has_one :android_app_invite
end
