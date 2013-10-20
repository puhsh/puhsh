class CreateFollowedCities < ActiveRecord::Migration
  def change
    create_table :followed_cities do |t|
      t.integer :user_id
      t.integer :city_id
      t.timestamps
    end
  end
end
