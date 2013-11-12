# Populate City Data 
# Customized from http://simplemaps.com/cities-data
if Rails.env.development? && City.count == 0
  ActiveRecord::Base.connection.execute(IO.read('db/city_data/texas-cities.sql'))
end

# Categories
Category.delete_all if Category.count == 0
['Kids Stuff'].each do |name|
  Category.create!(name: name)
end

# Subcategories
Subcategory.delete_all if Subcategory.count == 0
['Babywearing', 'Bedding', 'Clothes', 'Diapers', 'Furniture', 'Gear', 'Lots & Multiple Items', 'Maternity & Nursing', 'Misc & Other', 'Shoes', 'Strollers & Carseats', 'Toy & Games'].each do |name|
  Subcategory.create!(category: Category.first, name: name)
end

# Badges
Badge.delete_all if Badge.count == 0
['Early Adopter', 'Newbie Poster', 'Hot Shopper', 'Super Shopper', 'Super Seller', 'First Purchase', 'One Stop Shopper', 'Personal Shopper', 'Power Puhsher', 'School Night', 'Going the Distance', 'Sharer', 'Socialite', 'Over Sharing', 'Trifecta', 'Covering the Bases', 'Road Warrior'].each do |name|
  Badge.create!(name: name)
end
