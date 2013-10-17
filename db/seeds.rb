# Populate City Data 
# Customized from http://simplemaps.com/cities-data
ActiveRecord::Base.connection.execute(IO.read('db/city_data/texas-cities.sql'))
