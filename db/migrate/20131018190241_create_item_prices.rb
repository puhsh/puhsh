class CreateItemPrices < ActiveRecord::Migration
  def change
    create_table :item_prices do |t|
      t.integer :item_id
      t.money :price
      t.timestamps
    end
  end
end
