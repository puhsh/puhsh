class RenameDeviceIdToDeviceTokenOnDevices < ActiveRecord::Migration
  def change
    rename_column :devices, :device_id, :device_token
  end
end
