class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.integer :user_id
      t.string :token
      t.datetime :expires_at, default: DateTime.now.in(2.weeks)
      t.timestamps
    end
  end
end
