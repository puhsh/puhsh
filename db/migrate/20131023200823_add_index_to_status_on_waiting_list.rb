class AddIndexToStatusOnWaitingList < ActiveRecord::Migration
  def change
    add_index :waiting_lists, :status
  end
end
