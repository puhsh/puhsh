class AppInvite < ActiveRecord::Base
  attr_accessible :status, :user
  acts_as_list
  symbolize :status, in: [:inactive, :active], scopes: true, methods: true, validate: false

  # Relations
  belongs_to :user
  
  # Callbacks
  before_create :set_status

  # Validations
  validates :device_id, presence: true
  validates :status, presence: true

  def self.total_active
    AppInvite.status(:active).count
  end

  def activate!
    self.update_attributes(status: :active)
  end

  def devices_in_front_of_current_device
    (self.position - self.class.total_active) - 1
  end

  protected

  def set_status
    self.status = :inactive
  end
end
