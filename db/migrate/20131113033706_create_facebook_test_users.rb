class CreateFacebookTestUsers < ActiveRecord::Migration
  def change
    create_table :facebook_test_users do |t|
      t.string :fbid

      t.timestamps
    end
    add_index :facebook_test_users, :fbid, :unique => true
  end
end
