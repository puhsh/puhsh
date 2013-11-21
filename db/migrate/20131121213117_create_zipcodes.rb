class CreateZipcodes < ActiveRecord::Migration
  def change
    create_table :zipcodes do |t|
      t.integer :city_id
      t.string :code
      t.string :city_name
      t.string :state
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
