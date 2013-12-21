class RemoveQuestionFromoffer < ActiveRecord::Migration
  def up
    remove_column :offers, :question
  end

  def down
    add_column :offers, :question, :string
  end
end
