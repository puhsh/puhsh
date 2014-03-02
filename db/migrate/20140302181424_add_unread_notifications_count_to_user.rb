class AddUnreadNotificationsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :unread_notifications_count, :integer, after: :star_count, default: 0
  end
end
