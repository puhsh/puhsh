class AppInvite < ActiveRecord::Base
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
    AppInvite.status(:active).count
  end

  def self.total_inactive
    AppInvite.status(:inactive).count + OFFSET
  end

  def self.total_waiting
    AppInvite.last.position - self.total_active
  end
end
