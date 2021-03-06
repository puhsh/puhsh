class Follow < ActiveRecord::Base
  attr_accessible :user, :followed_user, :user_id, :followed_user_id

  # Relations
  belongs_to :user
  belongs_to :followed_user, class_name: 'User', foreign_key: 'followed_user_id'
  
  # Callbacks
  after_commit :store_user_ids_for_users, on: :create
  after_commit :remove_user_ids_for_users, on: :destroy

  # Validations
  validates :followed_user_id, uniqueness: { scope: :user_id }
  
  # Methods
  
  protected

  def store_user_ids_for_users
    self.user.user_ids_followed << self.followed_user_id
    self.followed_user.user_ids_following_self << self.user_id
  end

  def remove_user_ids_for_users
    self.user.user_ids_followed.delete(self.followed_user_id)
    self.followed_user.user_ids_following_self.delete(self.user_id)
  end
end
