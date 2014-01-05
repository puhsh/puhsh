class RenameWallPostTypeToPostType < ActiveRecord::Migration
  def up
    rename_column :wall_posts, :type, :post_type
  end

  def down
    rename_column :wall_posts, :post_type, :type
  end
end
