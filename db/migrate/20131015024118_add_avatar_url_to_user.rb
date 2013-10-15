class AddAvatarUrlToUser < ActiveRecord::Migration
  def up
    add_column :users, :avatar_url, :string, after: :last_name
  end

  def down
    remove_column :users, :avatar_url
  end
end
