class CreateWallPosts < ActiveRecord::Migration
  def change
    create_table :wall_posts do |t|
      t.integer :user_id
      t.string :type
      t.timestamps
    end

    add_index :wall_posts, :user_id
  end
end
