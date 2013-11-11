class Star < ActiveRecord::Base
  attr_accessible :user, :amount, :reason
  symbolize :reason, in: [:new_account], scopes: false, methods: false

  # Relations
  belongs_to :user

  # Callbacks
  
  # Validations
  validates :amount, presence: true
  validates :reason, presence: true
end
