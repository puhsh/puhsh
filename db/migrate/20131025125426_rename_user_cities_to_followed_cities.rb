class RenameUserCitiesToFollowedCities < ActiveRecord::Migration
  def change
    rename_table :user_cities, :followed_cities
  end
end
