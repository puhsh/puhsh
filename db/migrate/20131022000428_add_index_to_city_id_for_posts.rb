class AddIndexToCityIdForPosts < ActiveRecord::Migration
  def up
    add_index :posts, :city_id
  end

  def down
    remove_index :posts, :city_id
  end
end
