class FollowedCitySerializer < ActiveModel::Serializer
  attributes :id, :city, :created_at, :updated_at, :user_id

  has_one :city
end
