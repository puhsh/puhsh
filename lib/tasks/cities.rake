namespace :cities do
  desc 'Loads Texas cities'
  task :load_texas_cities => :environment do
    ActiveRecord::Base.connection.execute(IO.read('db/city_data/texas-cities.sql'))
  end
end
