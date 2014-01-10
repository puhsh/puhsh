class Follow < ActiveRecord::Base
  attr_accessible :user, :followed_user, :user_id, :followed_user_id

  # Relations
  belongs_to :user
  belongs_to :followed_user, class_name: 'User', foreign_key: 'followed_user_id'
  
  # Callbacks
  after_commit :store_user_ids_for_users, on: :create


  # Validations
  
  # Methods
  
  protected

  def store_user_ids_for_users
    self.user.user_ids_followed << self.followed_user_id
    self.followed_user.user_ids_following_self << self.user_id
  end
end
