class HomeCitySerializer < ActiveModel::Serializer
  attributes :id, :name, :state, :full_state_name, :pioneer_of_city

  def pioneer_of_city
    if current_user
      object.pioneer?(current_user)
    else
      false
    end
  end

  def name
    "#{object.name}, #{object.state}"
  end
end
