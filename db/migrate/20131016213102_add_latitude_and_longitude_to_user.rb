class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float, after: :state
    User.reset_column_information
    add_column :users, :longitude, :float, after: :latitude
  end
end
