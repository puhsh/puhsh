class Offer < ActiveRecord::Base
  symbolize :status, in: [:pending, :accepted, :rejected], methods: true, scopes: false, validates: true, default: :pending

  # Relations
  belongs_to :user
  belongs_to :item

  # Callbacks

  # Validations
end
