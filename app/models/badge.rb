class Badge < ActiveRecord::Base
  attr_accessible :name

  # Relations
  has_many :user_badges
  has_many :users, through: :user_badges

  # Callbacks
  
  # Validations
  validates :name, presence: true
end
