class AddCounterCacheToUserForFlaggedPost < ActiveRecord::Migration
  def up
    add_column :users, :posts_flagged_count, :integer, default: 0
    User.reset_column_information
    User.find(:all).each do |u|
      User.reset_counters u.id, :flagged_posts
    end
  end

  def dowm
    remove_column :users, :posts_flagged_count
  end
end
