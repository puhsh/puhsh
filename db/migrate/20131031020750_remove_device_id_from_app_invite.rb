class RemoveDeviceIdFromAppInvite < ActiveRecord::Migration
  def change
    remove_column :app_invites, :device_id
  end
end
