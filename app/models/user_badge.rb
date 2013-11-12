class UserBadge < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :badge

  # Callbacks
  
  # Validations
end
