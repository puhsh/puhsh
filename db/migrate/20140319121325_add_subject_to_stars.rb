class AddSubjectToStars < ActiveRecord::Migration
  def change
    add_column :stars, :subject_id, :integer, after: :event
    add_column :stars, :subject_type, :string, after: :subject_id
    add_index :stars, [:subject_id, :subject_type]
  end
end
