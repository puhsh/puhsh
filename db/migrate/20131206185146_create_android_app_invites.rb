class CreateAndroidAppInvites < ActiveRecord::Migration
  def change
    create_table :android_app_invites do |t|
      t.string :status
      t.timestamps
      t.integer :user_id
      t.integer :position
    end
    
    add_index :android_app_invites, :user_id
  end
end
