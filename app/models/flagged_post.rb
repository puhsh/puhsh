class FlaggedPost < ActiveRecord::Base
  attr_accessible :user, :user_id, :post, :post_id

  # Relations
  belongs_to :post, counter_cache: :flags_count
  belongs_to :user, counter_cache: :posts_flagged_count

  # Callbacks
  after_commit :store_flagged_post_id_for_user, on: :create

  # Validations
  validates :post_id, uniqueness: { scope: :user_id }

  # Methods

  protected

  def store_flagged_post_id_for_user
    self.user.flagged_post_ids << self.post_id
  end
end
