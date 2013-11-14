class AddIndexToAppInvite < ActiveRecord::Migration
  def change
    add_index :app_invites, :user_id
  end
end
