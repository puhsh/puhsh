class AddIndexesToCities < ActiveRecord::Migration
  def change
    add_index :cities, :zipcode
    add_index :cities, :latitude
    add_index :cities, :longitude
  end
end
