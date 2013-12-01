class Item < ActiveRecord::Base
  attr_accessible :price_cents
  monetize :price_cents

  # Relations
  belongs_to :post
  has_many :offers

  # Callbacks
  
  # Validations
end
