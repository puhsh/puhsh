class RemoveTitleAndDescriptionFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :title
    remove_column :items, :description
  end

  def down
    add_column :items, :title, :string
    add_column :items, :description, :string
  end
end
