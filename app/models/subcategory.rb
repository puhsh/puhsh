class Subcategory < ActiveRecord::Base
  attr_accessible :name, :category, :category_id, :status
  symbolize :status, in: [:active, :inactive], methods: true, scopes: true

  # Relations
  belongs_to :category
  has_many :posts

  # Callbacks

  # Validations
  validates :category, presence: true
  validates :name, presence: true
end
