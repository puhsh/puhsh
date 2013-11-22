class AddIndexToZipCodeLatLong < ActiveRecord::Migration
  def change
    add_index :zipcodes, :latitude
    add_index :zipcodes, :longitude
  end
end
