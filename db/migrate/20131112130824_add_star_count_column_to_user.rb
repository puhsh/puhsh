class AddStarCountColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :star_count, :integer, default: 0
  end
end
