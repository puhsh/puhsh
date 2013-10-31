class AppInvite < ActiveRecord::Base
  attr_accessible :status, :user
  acts_as_list
  symbolize :status, in: [:inactive, :active], scopes: true, methods: true, validate: false

  # Relations
  belongs_to :user
  
  # Callbacks
  before_create :set_status

  # Validations
  validates :status, presence: true

  def self.total_active
    AppInvite.status(:active).count
  end

  def self.total_inactive
    AppInvite.status(:inactive).count
  end

  def activate!
    self.update_attributes(status: :active)
  end

  def users_in_front_of_user
    (self.position - self.class.total_active) - 1
  end

  def current_position
    self.position - self.class.total_active
  end

  protected

  def set_status
    self.status = :inactive
  end
end
