class AddIndexToLatLongOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :latitude
    add_index :users, :longitude
  end
end
