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
    s = Sunspot.search City do
      fields(:city_name, :state, :zipcode)
    end
    s.results
  end
  
  # Solr
  # searchable auto_index: true, auto_remove: true do 
  #   text :state, :city_name
  #   text :zipcode do
  #     self.zipcodes
  #   end
  # end

  # Methods
  def follow!(user)
    FollowedCity.create({user: user, city: self})
  end
end
