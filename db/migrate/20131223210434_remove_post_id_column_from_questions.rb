class RemovePostIdColumnFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :post_id
  end

  def down
    add_column :questions, :post_id, :integer, after: :user_id
  end
end
