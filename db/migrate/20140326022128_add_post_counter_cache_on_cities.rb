class AddPostCounterCacheOnCities < ActiveRecord::Migration
  def up
    add_column :cities, :posts_count, :integer, default: 0
  end

  def down
    remove_column :cities, :posts_count
  end
end
