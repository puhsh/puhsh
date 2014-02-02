class AddDefaultValueToMessages < ActiveRecord::Migration
  def change
    change_column :messages, :read, :boolean, default: 0
  end
end
