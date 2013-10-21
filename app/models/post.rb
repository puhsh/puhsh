class Post < ActiveRecord::Base
  symbolize :payment_type, in: [both: 'Insta-Payment & Cash', cash: 'Cash Only', insta_payment: 'Insta-Payment Only', free: 'Item is Free'],
            methods: true, scope: false

  # Relations
  has_many :items, dependent: :destroy
  belongs_to :user

  # Callbacks

  # Validations
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

end
