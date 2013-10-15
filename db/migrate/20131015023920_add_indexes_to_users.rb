class AddIndexesToUsers < ActiveRecord::Migration
  def up
    add_index :users, :uid
    add_index :users, :first_name
    add_index :users, :last_name
  end

  def down
    remove_index :users, :uid
    remove_index :users, :first_name
    remove_index :users, :last_name
  end
end
