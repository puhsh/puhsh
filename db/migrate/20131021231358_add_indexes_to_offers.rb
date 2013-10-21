class AddIndexesToOffers < ActiveRecord::Migration
  def up
    add_index :offers, :user_id
    add_index :offers, :item_id
  end

  def down
    remove_index :offers, :user_id
    remove_index :offers, :item_id
  end
end
