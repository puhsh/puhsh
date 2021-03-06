class City < ActiveRecord::Base
  include FriendlyId
  include Sortable
  include Redis::Objects

  attr_accessible :state, :name, :full_state_name
  friendly_id :full_city_state, use: :slugged

  # Relations
  has_many :users
  has_many :followed_cities
  has_many :users, through: :followed_cities
  has_many :home_users, class_name: 'User', foreign_key: 'city_id', dependent: :nullify
  has_many :posts
  has_many :zipcodes, dependent: :destroy

  # Callbacks
  
  # Validations
  
  # Scopes
  scope :us_states, -> { select(:state, :full_state_name, :slug).group(:state) }

  # Redis Attributes
  set :user_ids_with_posts_in_city
  
  # Solr
  searchable do 
    text :name, boost: 5.0
    text :state
    text :full_state_name

    # Ordering / Filtering purposes
    string :name
    string :full_state_name
  end

  # Methods
  def self.search(query, opts = {})
    defaults = { page: 1, per_page: 25 }
    opts = defaults.merge(opts)

    Sunspot.search City do
      fulltext query do
        fields(:name, :state, :full_state_name)
      end

      paginate page: opts[:page], per_page: opts[:per_page]
      order_by :full_state_name, :asc
      order_by :name, :asc
    end.results
  end

  def full_city_state
    "#{self.name.try(&:downcase)}-#{self.full_state_name.try(&:downcase)}"
  end

  def follow!(user)
    FollowedCity.create({user: user, city: self})
  end

  def number_of_users_with_posts_in_city
    self.user_ids_with_posts_in_city.members.size
  end

  def user_has_post_in_city?(user)
    self.user_ids_with_posts_in_city.member?(user.id.to_s)
  end

  def pioneer?(user)
    self.number_of_users_with_posts_in_city == 1 && self.user_has_post_in_city?(user)
  end
end
