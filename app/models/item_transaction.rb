class ItemTransaction < ActiveRecord::Base
  symbolize :payment_type, in: [:cash, :insta_payment, :free], methods: true, scopes: false, i18n: false, validate: false

  # Relations
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :post
  belongs_to :item
  belongs_to :offer

  # Callbacks
  after_commit :send_item_purchased_email, on: :create
  
  # Validations

  # Methods
  
  protected

  def send_item_purchased_email
    if !self.offer.sold_offline?
      Puhsh::Jobs::EmailJob.send_item_purchased_email({post_id: self.post_id, user_id: self.buyer_id})
    end
  end
end
