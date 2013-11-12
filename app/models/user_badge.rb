class UserBadge < ActiveRecord::Base
  attr_accessible :user, :badge
  # Relations
  belongs_to :user
  belongs_to :badge

  # Callbacks
  
  # Validations
end
