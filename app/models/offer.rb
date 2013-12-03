class Offer < ActiveRecord::Base
  symbolize :status, in: [:pending, :accepted, :rejected, :awarded], methods: true, scopes: false, validates: true, default: :pending
  monetize :amount_cents

  # Relations
  belongs_to :user
  belongs_to :item

  # Callbacks

  # Validations
  
  # Methods
  def free?
    self.amount_cents == 0
  end
end
