class ChangeIndexOnUsers < ActiveRecord::Migration
  def up
    remove_index :users, :uid
    add_index :users, :uid, :unique => true
  end

  def down
    remove_index :users, :uid
    add_index :users, :uid
  end
end
