class AppInviteSerializer < ActiveModel::Serializer
  attributes :id, :position_at_sign_up, :people_in_front, :status, :number_of_people_active, :number_of_people_inactive

  def position_at_sign_up
    object.position
  end

  def people_in_front
    object.devices_in_front_of_current_device
  end

  def number_of_people_active
    object.class.total_active
  end

  def number_of_people_inactive
    object.class.total_inactive
  end
end
