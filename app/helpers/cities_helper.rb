module CitiesHelper
  def city_state_name(city)
    "#{city.name}, #{city.full_state_name}"
  end
end
