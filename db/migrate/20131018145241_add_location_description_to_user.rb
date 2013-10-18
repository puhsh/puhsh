class AddLocationDescriptionToUser < ActiveRecord::Migration
  def up
    add_column :users, :location_description, :string, after: :zipcode
  end

  def down
    remove_column :users, :location_description
  end
end
