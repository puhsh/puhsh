class Addindextodevices < ActiveRecord::Migration
  def up
    add_index :devices, :user_id
  end

  def down
    remove_index :devices, :user_id
  end
end
