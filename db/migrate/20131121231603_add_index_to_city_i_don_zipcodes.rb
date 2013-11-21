class AddIndexToCityIDonZipcodes < ActiveRecord::Migration
  def change
    add_index :zipcodes, :city_id
  end
end
