class AppInvite < ActiveRecord::Base
  OFFSET = 2215
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
    AppInvite.status(:inactive).count + OFFSET
  end

  def self.total_waiting
    AppInvite.last.position - self.total_active
  end

  def activate!
    self.update_attributes(status: :active)
    self.user.devices.each { |x| x.fire_notification!("Your invite to Puhsh has been accepted.", :app_invite_accepted) } if self.user
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
