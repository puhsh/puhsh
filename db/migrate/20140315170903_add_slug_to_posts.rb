class AddSlugToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string, after: :title
    add_index :posts, :slug, unique: true, null: false
  end
end
