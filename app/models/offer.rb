class Offer < ActiveRecord::Base
  attr_accessible :user, :item, :user_id, :amount_cents, :item_id, :post, :post_id, :status
  symbolize :status, in: [:pending, :accepted, :rejected, :awarded, :cancelled], methods: true, scopes: :shallow, validates: true, default: :pending
  monetize :amount_cents

  # Relations
  belongs_to :user
  belongs_to :item
  belongs_to :post
  has_one :item_transaction

  # Callbacks
  after_commit :store_post_id_for_user, on: :create
  before_save :generate_item_transaction_record
  after_commit :remove_post_id_from_redis, on: :destroy

  # Validations
  
  # Methods
  def free?
    self.amount_cents == 0
  end

  def accepted!
    self.status = :accepted
    self.save
  end

  def awarded!
    self.status = :awarded
    self.save
  end

  def item_sold!
    if self.status_changed? && self.awarded? && self.status_was != :awarded
      ItemTransaction.new.tap do |transaction|
        transaction.seller_id = self.post.user_id
        transaction.buyer_id = self.user_id
        transaction.post_id = self.post_id
        transaction.item_id = self.item_id
        transaction.offer_id = self.id
        transaction.payment_type = self.post.payment_type
        transaction.sold_on = DateTime.now
      end.save
    end
  end

  protected

  def store_post_id_for_user
    self.user.post_ids_with_offers << self.post_id
  end

  def generate_item_transaction_record
    item_sold!
  end

  def remove_post_id_from_redis
    self.user.post_ids_with_offers.delete(self.post_id)
  end
end
