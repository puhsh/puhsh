class AddConfirmableToDevise < ActiveRecord::Migration
  def up
    add_column :users, :confirmation_token, :string, after: :last_sign_in_ip
    add_column :users, :confirmed_at, :datetime, after: :confirmation_token
    add_column :users, :confirmation_sent_at, :datetime, after: :confirmed_at
    add_index :users, :confirmation_token, :unique => true
    User.update_all(:confirmed_at => Time.now)
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
