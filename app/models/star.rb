class Star < ActiveRecord::Base
  attr_accessible :user, :amount, :event
  symbolize :event, in: [:new_account, :alpha_registration], scopes: false, methods: false

  # Relations
  belongs_to :user

  # Callbacks
  after_create :update_user_star_count
  
  # Validations
  validates :amount, presence: true
  validates :event, presence: true

  protected

  def update_user_star_count
    self.user.update_attributes(star_count: Star.sum(:amount, conditions: {user_id: self.user_id}))
  end
end
