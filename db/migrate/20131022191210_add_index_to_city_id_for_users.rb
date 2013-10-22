class AddIndexToCityIdForUsers < ActiveRecord::Migration
  def up
    add_index :users, :city_id
  end

  def down
    remove_index :users, :city_id
  end
end
