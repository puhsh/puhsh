class Category < ActiveRecord::Base
  include Sortable

  attr_accessible :name
  symbolize :status, in: [:active, :inactive], methods: true, scopes: :shallow

  # Relations
  has_many :posts
  has_many :subcategories

  # Callbacks

  # Validations
  validates :name, presence: true
  
  # Scopes
  scope :active, -> { where(status: :active) }
  scope :alpha_by_category, -> { order('categories.name asc') }
  scope :alpha_by_subcategory, -> { order('subcategories.name asc') }
end
