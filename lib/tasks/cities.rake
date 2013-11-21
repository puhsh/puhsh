namespace :cities do
  # Customized from http://simplemaps.com/cities-data
  desc 'Loads US Zipcodes'
  task :load_us_zipcodes => :environment do
    Zipcode.delete_all
    ActiveRecord::Base.connection.execute('ALTER TABLE zipcodes AUTO_INCREMENT = 1')
    ActiveRecord::Base.connection.execute(IO.read('db/city_data/us-cities.sql'))
  end

  desc 'Populate US Cities'
  task :populate_us_cities => :environment do
    City.delete_all
    ActiveRecord::Base.connection.execute('ALTER TABLE cities AUTO_INCREMENT = 1')
    Zipcode.group(:city_name, :state).order('city_name, state asc').find_in_batches(batch_size: 10000) do |zipcodes|
      zipcodes.each do |zipcode|
        City.create(state: zipcode.state, city: zipcode.city_name)
      end
    end
  end

  desc 'Associate cities to zipcodes'
  task :associate_cities_to_zipcodes => :environment do
    Zipcode.find_in_batches(batch_size: 10000) do |zipcodes|
      zipcodes.each do |zipcode|
        zipcode.city = City.where(name: zipcode.city_name, state: zipcode.state).first
        zipcode.created_at = DateTime.now
        zipcode.save
      end
    end
  end
end
