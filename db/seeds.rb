# Populate City Data 
if Rails.env.development? && City.count == 0
  City.create(name: 'Frisco', state: 'TX')
  Zipcode.create(city: City.first, code: '75034', city_name: 'Frisco', state: 'TX', latitude: 33.1499, longitude: -96.8241)
end

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

# Badges
Badge.delete_all
['Early Adopter', 'Newbie Poster', 'Hot Shopper', 'Super Shopper', 'Super Seller', 'First Purchase', 'One Stop Shopper', 'Personal Shopper', 'Power Puhsher', 'School Night', 'Going the Distance', 'Sharer', 'Socialite', 'Over Sharing', 'Trifecta', 'Covering the Bases', 'Road Warrior'].each do |name|
  Badge.create!(name: name)
end
