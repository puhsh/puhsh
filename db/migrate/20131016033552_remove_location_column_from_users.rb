class RemoveLocationColumnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :location
  end

  def down
    add_column :useres, :location, :string, after: :avatar_url
  end
end
