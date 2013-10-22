class AddCityIdToPost < ActiveRecord::Migration
  def up
    add_column :posts, :city_id, :integer, after: :user_id
  end

  def down
    remove_column :posts, :city_id
  end
end
