class Subcategory < ActiveRecord::Base
  include Sortable

  attr_accessible :name, :category, :category_id, :status
  symbolize :status, in: { active: 'Active', inactive: 'Inactive' }, methods: true, scopes: :shallow

  # Relations
  belongs_to :category
  has_many :posts

  # Callbacks

  # Validations
  validates :category, presence: true
  validates :name, presence: true
  
  # Scopes
  scope :active, -> { where(status: :active) }
end
