class Post < ActiveRecord::Base
  symbolize :pick_up_location, in: [porch: 'Porch Pick Up', public_location: 'Meet at Public Location', house: 'Pickup at House', other: 'Other'],
            methods: true, scope: false, validates: true

  symbolize :payment_type, in: [both: 'Insta-Payment & Cash', cash: 'Cash Only', insta_payment: 'Insta-Payment Only', free: 'Item is Free'],
            methods: true, scope: false, validates: true

  # Relations
  has_many :items, dependent: :destroy
  belongs_to :user
  belongs_to :city
  has_many :flagged_posts

  # Callbacks

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

end
