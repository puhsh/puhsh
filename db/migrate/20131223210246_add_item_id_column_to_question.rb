class AddItemIdColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :item_id, :integer, after: :user_id
    add_index :questions, :item_id
  end
end
