class AndroidAppInvite < ActiveRecord::Base
  include Puhsh::AlphaQueue

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
    AndroidAppInvite.status(:active).count
  end

  def self.total_inactive
    AndroidAppInvite.status(:inactive).count + OFFSET
  end

  def self.total_waiting
    AndroidAppInvite.last.position - self.total_active
  end
end
