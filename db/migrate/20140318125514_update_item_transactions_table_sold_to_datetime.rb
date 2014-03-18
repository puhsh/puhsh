class UpdateItemTransactionsTableSoldToDatetime < ActiveRecord::Migration
  def up
    change_column :item_transactions, :sold_on, :datetime
  end

  def down
    change_column :item_transactions, :sold_on, :date
  end
end
