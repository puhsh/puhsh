class City < ActiveRecord::Base
  attr_accessible :state, :name

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
    text :state, :name
    text :zipcode do
      self.zipcodes.collect(&:code)
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
