class AddCityAndStateToUser < ActiveRecord::Migration
  def up
    add_column :users, :city, :string, after: :avatar_url
    User.reset_column_information
    add_column :users, :state, :string, after: :city
  end

  def down
    remove_column :users, :city
    remove_column :users, :state
  end
end
