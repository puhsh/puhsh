class AddDeviceTypeToAppInvite < ActiveRecord::Migration
  def change
    add_column :app_invites, :device_type, :string, after: :status
    add_index :app_invites, :status
  end
end
