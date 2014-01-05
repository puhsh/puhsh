class AddIndexToWallPosts < ActiveRecord::Migration
  def change
    add_index :wall_posts, :type
  end
end
