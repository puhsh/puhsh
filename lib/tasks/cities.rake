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
    Zipcode.where('city_id is null').group(:city_name, :state).order('city_name, state asc').find_in_batches(batch_size: 10000) do |zipcodes|
      zipcodes.each do |zipcode|
        if zipcode.location_type == 'PRIMARY'
          city_name = zipcode.city_name.split(" ").map(&:capitalize).join(" ")
          City.create(state: zipcode.state, name: city_name)
        else
          zipcode.destroy
        end
      end
    end
  end

  desc 'Associate cities to zipcodes'
  task :associate_cities_to_zipcodes => :environment do
    Zipcode.where('city_id is null').find_in_batches(batch_size: 10000) do |zipcodes|
      zipcodes.each do |zipcode|
        zipcode.city = City.where(name: zipcode.city_name, state: zipcode.state).first
        zipcode.created_at = DateTime.now
        zipcode.save
      end
    end
  end

  desc 'Populate full state name for cities'
  task :populate_full_state_name => :environment do
    states = {
      "Alabama" => "AL",
      "Alaska" => "AK",
      "Arizona" => "AZ",
      "Arkansas" => "AR",
      "California" => "CA",
      "Colorado" => "CO",
      "Connecticut" => "CT",
      "Delaware" => "DE",
      "Florida" => "FL",
      "Georgia" => "GA",
      "Hawaii" => "HI",
      "Idaho" => "ID",
      "Illinois" => "IL",
      "Indiana" => "IN",
      "Iowa" => "IA",
      "Kansas" => "KS",
      "Kentucky" => "KY",
      "Louisiana" => "LA",
      "Maine" => "ME",
      "Maryland" => "MD",
      "Massachusetts" => "MA",
      "Michigan" => "MI",
      "Minnesota" => "MN",
      "Mississippi" => "MS",
      "Missouri" => "MO",
      "Montana" => "MT",
      "Nebraska" => "NE",
      "Nevada" => "NV",
      "New Hampshire" => "NH",
      "New Jersey" => "NJ",
      "New Mexico" => "NM",
      "New York" => "NY",
      "North Carolina" => "NC",
      "North Dakota" => "ND",
      "Ohio" => "OH",
      "Oklahoma" => "OK",
      "Oregon" => "OR",
      "Pennsylvania" => "PA",
      "Puerto Rico" => "PR",
      "Rhode Island" => "RI",
      "South Carolina" => "SC",
      "South Dakota" => "SD",
      "Tennessee" => "TN",
      "Texas" => "TX",
      "Utah" => "UT",
      "Vermont" => "VT",
      "Virginia" => "VA",
      "Washington" => "WA",
      "West Virginia" => "WV",
      "Wisconsin" => "WI",
      "Wyoming" => "WY",
      "Virgin Islands" => "VI",
      "Washington DC" => "DC",
      "Guam" => "GU",
      "US Armed Forces Pacific" => "AP",
      "Palau" => "PW",
      "Marshall Islands" => "MH",
      "Federated States of Micronesia" => "FM",
      "Northern Mariana Islands" => "MP",
      "American Samoa" => "AS",
      "US Armed Forces Europe" => "AE",
      "US Armed Forces Americas" => "AA"
    }
    states.each do |full_state_name, abbrv|
      cities = City.where(state: abbrv)
      cities.update_all(full_state_name: full_state_name)
    end
  end

  desc 'Assign home cities to users'
  task :assign_home_cities_to_users => :environment do
    User.find_each do |user|
      city = Zipcode.near(user, 5).first.city
      user.home_city = city
      user.save
    end
  end
end
