class UpdateNotificationsAndMessagesReadAtToDatetime < ActiveRecord::Migration
  def up
    change_column :notifications, :read_at, :datetime
    change_column :messages, :read_at, :datetime
  end

  def down
    change_column :notifications, :read_at, :date
    change_column :messages, :read_at, :date
  end
end
