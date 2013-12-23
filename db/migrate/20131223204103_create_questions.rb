class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :content
      t.timestamps
    end

    add_index :questions, :user_id
    add_index :questions, :post_id
  end
end
