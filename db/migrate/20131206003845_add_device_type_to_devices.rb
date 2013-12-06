class AddDeviceTypeToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :device_type, :string, after: :user_id
  end
end
