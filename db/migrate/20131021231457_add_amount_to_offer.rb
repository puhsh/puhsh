class AddAmountToOffer < ActiveRecord::Migration
  def change
    add_money :offers, :amount
  end
end
