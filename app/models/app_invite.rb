class AppInvite < ActiveRecord::Base
  include Puhsh::AlphaQueue

  attr_accessible :status, :user, :device_type
  acts_as_list
  symbolize :status, in: [:inactive, :active], scopes: true, methods: true, validate: false
  symbolize :device_type, in: [:inactive, :active], scopes: true, methods: false, validate: false

  # Relations
  belongs_to :user
  
  # Callbacks
  before_create :set_status
  before_create :set_device_type

  # Validations
  validates :status, presence: true
  validates :device_type, presence: true

  def self.total_active
    AppInvite.status(:active).count
  end

  def self.total_inactive
    AppInvite.status(:inactive).count + OFFSET
  end

  def self.total_waiting
    AppInvite.last.position - self.total_active
  end

  protected

  def set_device_type
    self.device_type = :ios unless self.device_type.present?
  end
end
