class AddPostIdToItem < ActiveRecord::Migration
  def up
    add_column :items, :post_id, :integer, after: :id
  end

  def down
    remove_column :items, :post_id
  end
end
