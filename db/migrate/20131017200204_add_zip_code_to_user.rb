class AddZipCodeToUser < ActiveRecord::Migration
  def up
    add_column :users, :zipcode, :string, after: :state
  end

  def down
    remove_column :users, :zipcode
  end

end
