class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :actor_id
      t.string :actor_type
      t.integer :content_id
      t.string :content_type
      t.boolean :read, default: false
      t.date :read_at
      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, :actor_id
    add_index :notifications, :actor_type
    add_index :notifications, :content_id
    add_index :notifications, :content_type
  end
end
