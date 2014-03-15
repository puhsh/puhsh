class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, after: :last_name
    add_index :users, :slug, unique: true, null: false
  end
end
