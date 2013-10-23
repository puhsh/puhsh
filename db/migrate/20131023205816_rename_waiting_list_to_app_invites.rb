class RenameWaitingListToAppInvites < ActiveRecord::Migration
  def up
    rename_table :waiting_lists, :app_invites
  end

  def down
    rename_table :app_invites, :waiting_lists
  end
end
