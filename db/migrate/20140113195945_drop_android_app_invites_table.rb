class DropAndroidAppInvitesTable < ActiveRecord::Migration
  def change
    drop_table :android_app_invites;
  end
end
