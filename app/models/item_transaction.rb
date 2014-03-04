class ItemTransaction < ActiveRecord::Base
  symbolize :payment_type, in: [:cash, :insta_payment, :free], methods: true, scopes: false, i18n: false, validate: false

  # Relations
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :post
  belongs_to :item
  belongs_to :offer

  # Callbacks
  
  # Validations

  # Methods
end
