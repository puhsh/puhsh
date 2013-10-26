class AddSubcategoryIndexes < ActiveRecord::Migration
  def up
    add_index :posts, :subcategory_id
    add_index :subcategories, :category_id
  end

  def down
    remove_index :posts, :subcategory_id
    remove_index :subcategories, :category_id
  end
end
