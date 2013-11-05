class AccessToken < ActiveRecord::Base
  attr_accessible :user, :token, :expires_at

  # Relations
  belongs_to :user

  # Callbacks
  before_save :generate_token

  # Validations
  
  def expired?
    DateTime.now > self.expires_at
  end

  protected

  def generate_token
    if self.token.blank?
      self.token = SecureRandom.hex
    else 
      self.update_attributes(token: SecureRandom.hex, expires_at: DateTime.now.in(2.weeks)) if self.expired?
    end
  end
end
