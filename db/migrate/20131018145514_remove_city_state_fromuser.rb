class RemoveCityStateFromuser < ActiveRecord::Migration
  def up
    remove_column :users, :state
    remove_column :users, :city
  end

  def down
    add_column :users, :state, :string
    add_column :users, :city, :string
  end
end
