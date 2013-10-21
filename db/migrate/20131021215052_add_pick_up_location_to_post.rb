class AddPickUpLocationToPost < ActiveRecord::Migration
  def up
    add_column :posts, :pick_up_location, :string, after: :description
  end

  def down
    remove_column :posts, :pick_up_location
  end
end
