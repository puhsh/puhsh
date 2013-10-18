class AddIndexToPostIdOnItem < ActiveRecord::Migration
  def up
    add_index :items, :post_id
  end

  def down
    remove_index :items, :post_id
  end
end
