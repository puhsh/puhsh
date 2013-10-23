class AddUserIdToWaitingList < ActiveRecord::Migration
  def change
    add_column :waiting_lists, :user_id, :integer
  end
end
