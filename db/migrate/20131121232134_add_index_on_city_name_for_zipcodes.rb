class AddIndexOnCityNameForZipcodes < ActiveRecord::Migration
  def change
    add_index :zipcodes, :city_name
  end
end
