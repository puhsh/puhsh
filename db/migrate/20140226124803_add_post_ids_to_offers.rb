class AddPostIdsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :post_id, :integer, after: :item_id
  end
end
