class Category < ActiveRecord::Base
  attr_accessible :name
  symbolize :status, in: [:active, :inactive], methods: true, scopes: true

  # Relations
  has_many :posts
  has_many :subcategories

  # Callbacks

  # Validations
  validates :name, presence: true
end