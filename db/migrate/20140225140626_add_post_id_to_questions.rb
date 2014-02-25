class AddPostIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :post_id, :integer, after: :item_id
    add_index :questions, :post_id
  end
end
