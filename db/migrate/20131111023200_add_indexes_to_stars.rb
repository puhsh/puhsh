class AddIndexesToStars < ActiveRecord::Migration
  def change
    add_index :stars, :user_id
  end
end
