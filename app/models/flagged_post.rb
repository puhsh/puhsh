class FlaggedPost < ActiveRecord::Base
  # Relations
  belongs_to :post
  belongs_to :user

  # Callbacks

  # Validations
end
