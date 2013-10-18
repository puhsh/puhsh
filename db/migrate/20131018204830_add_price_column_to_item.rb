class AddPriceColumnToItem < ActiveRecord::Migration
  def up
    add_money :items, :price
  end

  def down
    remove_column :items, :price
  end
end
