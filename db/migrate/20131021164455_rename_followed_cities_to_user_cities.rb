class RenameFollowedCitiesToUserCities < ActiveRecord::Migration
  def change
    rename_table :followed_cities, :user_cities
  end
end
