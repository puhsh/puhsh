class AddQuestionToOffer < ActiveRecord::Migration
  def up
    add_column :offers, :question, :string, after: :status
  end

  def down
    remove_column :offers, :question
  end
end
