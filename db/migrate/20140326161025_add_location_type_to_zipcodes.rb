class AddLocationTypeToZipcodes < ActiveRecord::Migration
  def change
    add_column :zipcodes, :location_type, :string, after: :longitude
  end
end
