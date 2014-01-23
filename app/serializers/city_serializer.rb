class CitySerializer < ActiveModel::Serializer
  root false
  attributes :id, :name, :state
end
