class FlaggedPost < ActiveRecord::Base
  # Relations
  belongs_to :post, counter_cache: :flags_count
  belongs_to :user

  # Callbacks

  # Validations
end
