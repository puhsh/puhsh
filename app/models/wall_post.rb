class WallPost < ActiveRecord::Base
  include StarRewardable
  include Trackable

  # posts_type values that do not appear here have no limit
  @@POST_TYPE_LIMITS = {
    alpha_share: 3,
    sms_share: 1,
    app_share: 1,
    email_share: 1
  }

  attr_accessible :user, :post_type
  symbolize :post_type, in: [:alpha_share, :post_share, :sms_share, :app_share, :sold_post_share, :email_share] , methods: true, scopes: false, validates: true

  # Relations
  belongs_to :user
  has_one :star, as: :subject

  # Callbacks

  # Validations
  validates :post_type, presence: true
  validate :limit_type_of_wall_posts
  
  # Methods

  protected

  def limit_type_of_wall_posts
    if @@POST_TYPE_LIMITS.has_key? self.post_type
      limit = @@POST_TYPE_LIMITS[self.post_type]
      if WallPost.where(user_id: self.user_id, post_type: self.post_type).count > limit
        errors.add(:post_type, "cannot have more than #{limit} wall posts of type #{self.post_type}")
      end
    end
  end
end
