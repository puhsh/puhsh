class AddIndexToBadgeName < ActiveRecord::Migration
  def change
    add_index :badges, :name
  end
end
