# Populate City Data 
# Customized from http://simplemaps.com/cities-data
# ActiveRecord::Base.connection.execute(IO.read('db/city_data/texas-cities.sql'))

# Categories
Category.delete_all
['Kids Stuff'].each do |name|
  Category.create!(name: name)
end

# Subcategories
Subcategory.delete_all
['Babywearing', 'Bedding', 'Clothes', 'Diapers', 'Furniture', 'Gear', 'Lots & Multiple Items', 'Maternity & Nursing', 'Misc & Other', 'Shoes', 'Strollers & Carseats', 'Toy & Games'].each do |name|
  Subcategory.create!(category: Category.first, name: name)
end
