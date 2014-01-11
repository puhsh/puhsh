class FlaggedPost < ActiveRecord::Base
  attr_accessible :user, :user_id, :post, :post_id

  # Relations
  belongs_to :post, counter_cache: :flags_count
  belongs_to :user, counter_cache: :posts_flagged_count

  # Callbacks

  # Validations
  validates :post_id, uniqueness: { scope: :user_id }
end
