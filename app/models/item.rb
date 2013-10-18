class Item < ActiveRecord::Base
  # Relations
  belongs_to :user
  has_many :item_prices, dependent: :destroy

end
