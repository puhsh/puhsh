class UserCity < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :city

  # Callbacks
end
