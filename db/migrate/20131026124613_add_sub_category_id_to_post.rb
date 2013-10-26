class AddSubCategoryIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :subcategory_id, :integer, after: :category_id
  end
end
