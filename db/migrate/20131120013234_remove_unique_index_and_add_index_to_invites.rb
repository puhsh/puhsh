class RemoveUniqueIndexAndAddIndexToInvites < ActiveRecord::Migration
  def change
    remove_index :invites, :uid_invited
    add_index :invites, :uid_invited
  end
end
