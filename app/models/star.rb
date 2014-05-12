class Star < ActiveRecord::Base
  include Sortable
  attr_accessible :user, :user_id, :amount, :event, :subject, :subject_id, :subject_type
  symbolize :event, in: [:new_account, :alpha_registration, :friend_invite, :new_post, :shared_wall_post, :shared_sms, :deleted_post, :sold_item, :bought_item, :pioneered_city, :shared_email], scopes: false, methods: false

  # Relations
  belongs_to :user
  belongs_to :subject, polymorphic: :true

  # Callbacks
  after_create :update_user_star_count
  
  # Validations
  validates :amount, presence: true
  validates :event, presence: true

  def self.award!(resource, event, amount)
    create(user: resource.user, amount: amount, event: event, subject: resource)
  end

  protected

  def update_user_star_count
    self.user.update_attributes(star_count: Star.where(user_id: self.user_id).calculate(:sum, :amount)) if self.user
  end
end
