class Star < ActiveRecord::Base
  attr_accessible :user, :amount, :event
  symbolize :event, in: [:new_account, :alpha_registration], scopes: false, methods: false

  # Relations
  belongs_to :user

  # Callbacks
  
  # Validations
  validates :amount, presence: true
  validates :event, presence: true
end
