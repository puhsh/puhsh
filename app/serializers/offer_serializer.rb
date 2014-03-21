class OfferSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :item_id, :post_id, :status, :created_at, :updated_at, :amount_cents, :amount_currency, :star_reward

  def star_reward
    if object.new_record?
      object.star
    end
  end
end
