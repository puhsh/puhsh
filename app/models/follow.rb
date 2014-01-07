class Follow < ActiveRecord::Base
  attr_accessible :user, :followed_user

  # Relations
  belongs_to :user
  belongs_to :followed_user, class_name: 'user', foreign_key: 'followed_user_id'
  
  # Callbacks

  # Validations
  
  # Methods
end
