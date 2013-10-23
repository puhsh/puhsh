class CreateWaitingLists < ActiveRecord::Migration
  def change
    create_table :waiting_lists do |t|
      t.string :device_id
      t.string :status
      t.timestamps
    end
  end
end
