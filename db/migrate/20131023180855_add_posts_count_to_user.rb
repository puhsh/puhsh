class AddPostsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :posts_count, :integer, after: :last_sign_in_ip, default: 0
  end
end
