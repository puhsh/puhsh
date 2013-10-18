class AddIndexToUserIDonItems < ActiveRecord::Migration
  def up
    add_index :items, :user_id
  end

  def down
    remove_index :items, :user_id
  end
end
