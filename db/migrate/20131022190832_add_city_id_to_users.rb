class AddCityIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :city_id, :integer, after: :longitude
  end

  def down
    remove_column :users, :city_id
  end
end
