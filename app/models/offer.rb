class Offer < ActiveRecord::Base
  attr_accessible :user, :item, :user_id, :amount_cents, :item_id
  symbolize :status, in: [:pending, :accepted, :rejected, :awarded, :cancelled], methods: true, scopes: false, validates: true, default: :pending
  monetize :amount_cents

  # Relations
  belongs_to :user
  belongs_to :item

  # Callbacks
  after_commit :store_post_id_for_user, on: :create
  after_commit :store_offer_id_for_post, on: :create

  # Validations
  
  # Methods
  def free?
    self.amount_cents == 0
  end

  protected

  def store_post_id_for_user
    self.user.post_ids_with_offers << self.item.post_id
  end

  def store_offer_id_for_post
    self.item.post.offer_ids << self.id
  end
end
