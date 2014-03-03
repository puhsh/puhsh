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

  # Validations
  
  # Methods
  def free?
    self.amount_cents == 0
  end

  protected

  def store_post_id_for_user
    self.user.post_ids_with_offers << self.post_id
  end
end
