class Post < ActiveRecord::Base
  # Relations
  has_many :items, dependent: :destroy
  belongs_to :user

  # Callbacks
end
