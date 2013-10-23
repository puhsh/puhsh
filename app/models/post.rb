class Post < ActiveRecord::Base
  attr_accessible :title, :description, :pick_up_location, :payment_type
  symbolize :pick_up_location, in: [porch: 'Porch Pick Up', public_location: 'Meet at Public Location', house: 'Pickup at House', other: 'Other'],
            methods: true, scope: false, i18n: false, validate: false

  symbolize :payment_type, in: [both: 'Insta-Payment & Cash', cash: 'Cash Only', insta_payment: 'Insta-Payment Only', free: 'Item is Free'],
            methods: true, scope: false, i18n: false, validate: false

  # Relations
  has_many :items, dependent: :destroy
  belongs_to :user, counter_cache: :posts_count
  belongs_to :city
  has_many :flagged_posts, dependent: :destroy

  # Callbacks

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :pick_up_location, presence: true
  validates :payment_type, presence: true
end
