class Post < ActiveRecord::Base
  include StarRewardable
  include BadgeRewardable
  include Sortable
  include Redis::Objects
  include Trackable
  include FriendlyId

  attr_accessible :title, :description, :pick_up_location, :payment_type, :category, :category_id, :subcategory, :subcategory_id, :city, :user_id, :item_attributes, :user, :post_images_attributes, :status
  symbolize :pick_up_location, in: { porch: 'Porch Pick Up', public_location: 'Meet at Public Location', house: 'Pickup at House', other: 'Other' },
            methods: true, scopes: false, i18n: false, validate: false

  symbolize :payment_type, in: { both: 'Insta-Payment & Cash', cash: 'Cash Only', insta_payment: 'Insta-Payment Only', free: 'Item is Free' },
            methods: true, scopes: false, i18n: false, validate: false

  symbolize :status, in: [:for_sale, :offer_accepted, :withdrawn_by_seller, :sold], methods: true, scopes: :shallow, validate: false, default: :for_sale

  friendly_id :title, use: :slugged

  # Relations
  belongs_to :user, counter_cache: :posts_count
  belongs_to :city, counter_cache: :posts_count
  belongs_to :category
  belongs_to :subcategory
  has_one :item, dependent: :destroy
  has_many :post_images, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :flagged_posts, dependent: :destroy
  has_one :item_transaction, dependent: :nullify
  has_one :star, as: :subject, dependent: :nullify

  # Callbacks
  before_save :add_category, :set_city
  after_commit :store_category_name, on: :create
  after_commit :store_subcategory_name, on: :create
  after_commit :send_new_post_email, on: :create
  after_commit :remove_post_id_from_redis, on: :destroy
  after_commit :store_users_who_have_posted_for_city, on: :create

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :pick_up_location, presence: true
  validates :payment_type, presence: true
  validates :category, presence: true

  # Scopes
  scope :for_cities, ->(city_ids) { where(city_id: city_ids) }
  scope :for_users, ->(user_ids) { where(user_id: user_ids) }
  scope :for_users_or_cities, ->(user_ids, city_ids) { Post.where(Post.where(user_id: user_ids, city_id: city_ids).where_values.inject(:or)) }
  scope :exclude_user, ->(user) { where.not(user_id: user.id) }
  scope :exclude_category_ids, ->(category_ids) { where.not(category_id: category_ids) }
  scope :exclude_post_ids, ->(post_ids) { where.not(id: post_ids) unless post_ids.blank? } 

  # Nested Attributes
  accepts_nested_attributes_for :item
  accepts_nested_attributes_for :post_images

  # Redis Attributes
  value :category_name
  value :subcategory_name
  
  # Solr
  searchable do 
    text :title, boost: 5.0
    text :description
    integer :category_id
    time :created_at
  end

  # Methods
  def self.search(query, page = 1, per_page = 25, opts = {})
    defaults = { without_category_ids: [] }
    opts = defaults.merge(opts)

    Sunspot.search Post do
      fulltext query do
        fields(:title)
      end

      # Additional Filtering
      without(:category_id, opts[:without_category_ids]) if opts[:without_category_ids].present?

      # Order and Pagination
      order_by :created_at, :desc
      paginate page: page, per_page: per_page
    end.results
  end
  
  def activity
    (offers + questions).sort_by(&:created_at)
  end

  def update_status!(status)
    return self unless status
    self.update_attributes(status: status)
  end

  def flagged_by?(user)
    if user
      user.flagged_post_ids.member?(self.id)
    else
      false
    end
  end

  def sold!
    self.update_attributes(status: :sold)
    self.reward_additional_stars!(self, :sold_item, 10)
  end

  protected

  def add_category
    self.category = Category.first unless self.category
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
  
  def store_users_who_have_posted_for_city
    self.city.user_ids_with_posts_in_city << self.user_id
  end

  def remove_post_id_from_redis
    u = self.user
    u.post_ids_with_questions.delete(self.id)
    u.post_ids_with_offers.delete(self.id)
    self.question_ids.clear
    self.category_name = nil
    self.subcategory_name = nil
  end
end
