class AppInviteSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_users_waiting, :current_position, :device_type

  def total_users_waiting
    object.class.total_waiting
  end
end
