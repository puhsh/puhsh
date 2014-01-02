class Post < ActiveRecord::Base
  include StarRewardable
  include BadgeRewardable
  include Redis::Objects

  attr_accessible :title, :description, :pick_up_location, :payment_type, :category, :category_id, :subcategory, :subcategory_id, :city, :user_id, :items_attributes, :user
  symbolize :pick_up_location, in: [porch: 'Porch Pick Up', public_location: 'Meet at Public Location', house: 'Pickup at House', other: 'Other'],
            methods: true, scope: false, i18n: false, validate: false

  symbolize :payment_type, in: [both: 'Insta-Payment & Cash', cash: 'Cash Only', insta_payment: 'Insta-Payment Only', free: 'Item is Free'],
            methods: true, scope: false, i18n: false, validate: false

  # Relations
  has_many :items, dependent: :destroy
  belongs_to :user, counter_cache: :posts_count
  belongs_to :city
  has_many :flagged_posts, dependent: :destroy
  belongs_to :category
  belongs_to :subcategory
  has_many :post_images, dependent: :destroy

  # Callbacks
  before_save :add_category, :set_city
  after_commit :store_category_name, on: :create
  after_commit :store_subcategory_name, on: :create

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :pick_up_location, presence: true
  validates :payment_type, presence: true
  validates :category, presence: true

  # Scopes
  scope :recent, order('created_at DESC')
  scope :for_cities, ->(city_ids) { where(city_id: city_ids) }
  scope :for_users, ->(user_ids) { where(user_id: user_ids) }
  scope :exclude_user, ->(user) { where('user_id != ?', user) }

  # Nested Attributes
  accepts_nested_attributes_for :items

  # Redis Attributes
  set   :offer_ids
  set   :question_ids
  value :category_name
  value :subcategory_name

  def offers
    Offer.where(id: offer_ids.members)
  end

  def questions 
    Question.where(id: question_ids.members)
  end

  def activity

  end

  protected

  # Default to Kids Stuff category since that is the only
  # product line we support for now
  def add_category
    self.category = Category.first
  end

  def set_city
    self.city = self.user.home_city
  end

  def store_category_name
    self.category_name.value = self.category.name
  end

  def store_subcategory_name
    self.subcategory_name.value = self.subcategory.name
  end
end
