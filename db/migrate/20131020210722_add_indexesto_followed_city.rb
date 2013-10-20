class AddIndexestoFollowedCity < ActiveRecord::Migration
  def up
    add_index :followed_cities, :user_id
    add_index :followed_cities, :city_id
  end

  def down
    remove_index :followed_cities, :user_id
    remove_index :followed_cities, :city_id
  end
end
