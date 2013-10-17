class City < ActiveRecord::Base
  geocoded_by :address
end
