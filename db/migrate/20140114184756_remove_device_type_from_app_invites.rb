class RemoveDeviceTypeFromAppInvites < ActiveRecord::Migration
  def change
    remove_column :app_invites, :device_type
  end
end
