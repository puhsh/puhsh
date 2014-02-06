class Post < ActiveRecord::Base
  include StarRewardable
  include BadgeRewardable
  include Redis::Objects

  attr_accessible :title, :description, :pick_up_location, :payment_type, :category, :category_id, :subcategory, :subcategory_id, :city, :user_id, :item_attributes, :user, :post_images_attributes, :status
  symbolize :pick_up_location, in: { porch: 'Porch Pick Up', public_location: 'Meet at Public Location', house: 'Pickup at House', other: 'Other' },
            methods: true, scope: false, i18n: false, validate: false

  symbolize :payment_type, in: { both: 'Insta-Payment & Cash', cash: 'Cash Only', insta_payment: 'Insta-Payment Only', free: 'Item is Free' },
            methods: true, scope: false, i18n: false, validate: false

  symbolize :status, in: [:for_sale, :offer_accepted, :withdrawn_by_seller, :sold], methods: true, scope: false, validate: false, default: :for_sale

  # Relations
  has_one :item, dependent: :destroy
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
  after_commit :send_new_post_email, on: :create

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
  scope :for_users_or_cities, ->(user_ids, city_ids) { where('user_id in (?) OR city_id in (?)', user_ids, city_ids) }
  scope :exclude_user, ->(user) { where('user_id != ?', user) }

  # Nested Attributes
  accepts_nested_attributes_for :item
  accepts_nested_attributes_for :post_images

  # Redis Attributes
  set   :offer_ids
  set   :question_ids
  value :category_name
  value :subcategory_name
  
  # Solr
  searchable do 
    text :title, boost: 5.0
    text :description
    time :created_at
  end

  # Methods
  def self.search(query, page = 1, per_page = 25)
    Sunspot.search Post do
      fulltext query do
        fields(:title, :description)
      end
      order_by :created_at, :desc
      paginate page: page, per_page: per_page
    end.results
  end

  def offers
    Offer.where(id: offer_ids.members)
  end
  
  def questions 
    Question.where(id: question_ids.members)
  end

  def activity
    (offers + questions).sort_by(&:created_at)
  end

  def update_status!(status)
    return self unless status
    self.update_attributes(status: status)
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

  def send_new_post_email
    Puhsh::Jobs::EmailJob.send_new_post_email({post_id: self.id})
  end
end
