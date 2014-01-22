class PostUserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :name, :first_name, :last_name, :avatar_url, :zipcode, :location_description, :latitude,
             :longitude, :gender, :facebook_email, :contact_email, :posts_count, :posts_flagged_count,
             :star_count, :is_following

  def is_following
    current_user.following?(object)
  end
end
