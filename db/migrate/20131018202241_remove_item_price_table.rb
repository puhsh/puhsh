class RemoveItemPriceTable < ActiveRecord::Migration
  def change
    drop_table :item_prices
  end
end
