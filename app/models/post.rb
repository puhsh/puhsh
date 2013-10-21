class Post < ActiveRecord::Base
  # Relations
  has_many :items, dependent: :destroy
  belongs_to :user

  # Callbacks

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

end
