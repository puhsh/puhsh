class Item < ActiveRecord::Base
  attr_accessible :price_cents, :post
  monetize :price_cents

  # Relations
  belongs_to :post
  has_many :offers, dependent: :destroy
  has_many :questions, dependent: :destroy

  # Callbacks
  
  # Validations
end
