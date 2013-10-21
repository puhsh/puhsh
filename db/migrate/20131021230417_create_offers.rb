class CreateOffers < ActiveRecord::Migration
  def up
    create_table :offers do |t|
      t.integer :user_id
      t.integer :item_id
      t.string :status, default: :pending
      t.timestamps
    end
  end

  def down
    drop_table :offers
  end

end
