class City < ActiveRecord::Base
  include FriendlyId

  attr_accessible :state, :name, :full_state_name
  friendly_id :name

  # Relations
  has_many :users
  has_many :followed_cities
  has_many :users, through: :followed_cities
  has_many :posts
  has_many :zipcodes

  # Callbacks
  
  # Validations
  
  # Solr
  searchable do 
    text :name, boost: 5.0
    text :state
    text :zipcode do
      self.zipcodes.map { |x| x.code }
    end
  end

  # Methods
  def self.search(query, page = 1, per_page = 25)
    Sunspot.search City do
      fulltext query do
        fields(:name, :state)
      end
      paginate page: page, per_page: per_page
    end.results
  end

  def follow!(user)
    FollowedCity.create({user: user, city: self})
  end
end
