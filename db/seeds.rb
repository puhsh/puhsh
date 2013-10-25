# Populate City Data 
# Customized from http://simplemaps.com/cities-data
ActiveRecord::Base.connection.execute(IO.read('db/city_data/texas-cities.sql'))

# Categories
Category.delete_all
['Kids Stuff'].each do |name|
  Category.create!(name: name)
end
