class Item < ActiveRecord::Base
  attr_accessible :price_cents, :post
  monetize :price_cents

  # Relations
  belongs_to :post
  has_many :offers
  has_many :questions
  has_one :item_transaction, dependent: :nullify

  # Callbacks
  
  # Validations
end
