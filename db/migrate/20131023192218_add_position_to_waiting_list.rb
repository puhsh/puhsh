class AddPositionToWaitingList < ActiveRecord::Migration
  def change
    add_column :waiting_lists, :position, :integer
  end
end
