class AddIndexToWaitingLists < ActiveRecord::Migration
  def change
    add_index :waiting_lists, :device_id
  end
end
