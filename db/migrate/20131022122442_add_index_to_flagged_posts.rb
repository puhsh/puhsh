class AddIndexToFlaggedPosts < ActiveRecord::Migration
  def up
    add_index :flagged_posts, :post_id
    add_index :flagged_posts, :user_id
  end

  def down
    remove_index :flagged_posts, :post_id
    remove_index :flagged_posts, :user_id
  end
end
