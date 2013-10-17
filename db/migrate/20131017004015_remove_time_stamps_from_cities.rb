class RemoveTimeStampsFromCities < ActiveRecord::Migration
  def change
    remove_column :cities, :created_at
    remove_column :cities, :updated_at
  end
end
