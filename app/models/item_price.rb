class ItemPrice < ActiveRecord::Base
  monetize :price_cents

  # Relations
  belongs_to :item
end
