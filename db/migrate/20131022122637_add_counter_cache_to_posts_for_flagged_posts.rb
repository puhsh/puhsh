class AddCounterCacheToPostsForFlaggedPosts < ActiveRecord::Migration
  def up
    add_column :posts, :flags_count, :integer, default: 0, after: :payment_type
    Post.reset_column_information
    Post.find(:all).each do |p|
      Post.reset_counters p.id, :flagged_posts
    end
  end

  def down
    remove_column :posts, :flags_count
  end
end
