class WallPost < ActiveRecord::Base
  include StarRewardable
  include Trackable

  attr_accessible :user, :post_type
  symbolize :post_type, in: [:alpha_share] , methods: true, scopes: false, validates: true

  # Relations
  belongs_to :user

  # Callbacks

  # Validations
  validates :post_type, presence: true
  validate :limit_type_of_wall_posts
  
  # Methods

  protected

  def limit_type_of_wall_posts
    if WallPost.where(user_id: self.user_id, post_type: self.post_type).count > 3
      errors.add(:post_type, 'cannot have more than three wall posts of this type')
    end
  end

end
