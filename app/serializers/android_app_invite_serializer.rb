class AndroidAppInviteSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_users_waiting, :current_position

  def total_users_waiting
    object.class.total_waiting
  end
end
