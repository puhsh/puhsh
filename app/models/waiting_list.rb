class WaitingList < ActiveRecord::Base
  attr_accessible :status
  symbolize :status, in: [:inactive, :active], methods: true, validate: false

  # Relations
  
  # Callbacks
  before_create :set_status

  # Validations
  validates :device_id, presence: true
  validates :status, presence: true

  def activate!
    self.update_attributes(status: :active)
  end

  protected

  def set_status
    self.status = :inactive
  end
end
