class AddIndexesToAccessToken < ActiveRecord::Migration
  def change
    add_index :access_tokens, :user_id
    add_index :access_tokens, :token
  end
end
