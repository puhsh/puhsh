class CreateItemTransactions < ActiveRecord::Migration
  def change
    create_table :item_transactions do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.integer :post_id
      t.integer :item_id
      t.integer :offer_id
      t.string :payment_type
      t.date :sold_on
      t.timestamps
    end

    add_index :item_transactions, :seller_id
    add_index :item_transactions, :buyer_id
    add_index :item_transactions, :post_id
    add_index :item_transactions, :item_id
    add_index :item_transactions, :offer_id
    add_index :item_transactions, :payment_type
  end
end
