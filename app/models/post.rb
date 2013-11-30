class Post < ActiveRecord::Base
  include StarRewardable
  attr_accessible :title, :description, :pick_up_location, :payment_type, :category, :subcategory, :city
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
  before_create :add_category, :set_city
  after_create :award_badges

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :pick_up_location, presence: true
  validates :payment_type, presence: true
  validates :category, presence: true

  protected

  # Default to Kids Stuff category since that is the only
  # product line we support for now
  def add_category
    self.category = Category.first
  end

  def set_city
    self.city = self.user.home_city
  end

  def award_badges
    Badge.award!('Newbie Poster', self.user) if self.user.posts_count_was == 0
  end
end
