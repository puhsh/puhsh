class Item < ActiveRecord::Base
  monetize :price_cents

  # Relations
  belongs_to :post

  # Callbacks
  
  # Validations
end
