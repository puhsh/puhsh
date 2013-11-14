class AppInviteSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_users_waiting, :current_position

  def total_users_waiting
    object.class.total_inactive + 216
  end
end
