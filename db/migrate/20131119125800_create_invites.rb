class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.string :uid_invited
      t.timestamps
    end

    add_index :invites, :user_id
    add_index :invites, :uid_invited, unique: true
  end
end
