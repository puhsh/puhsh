class AddIndexToCityState < ActiveRecord::Migration
  def change
    add_index :cities, :state
  end
end
