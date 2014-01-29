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
  
  # Scopes
  scope :search, ->(query) do 
    Sunspot.search City do
      fulltext query do
        fields(:name, :state)
      end
    end
  end
  
  # Solr
  searchable do 
    text :state, :name
    text :zipcode do
      self.zipcodes.collect(&:code)
    end
  end

  # Methods
  def follow!(user)
    FollowedCity.create({user: user, city: self})
  end
end
