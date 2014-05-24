module CitiesHelper
  def city_state_name(city)
    "#{city.name}, #{city.full_state_name}"
  end

  def city_founded_date(city, style = :none)
    date_founded = city.followed_cities.first.created_at
    if style == :fancy
      Time.zone.local_to_utc(date_founded).strftime("%m.%d.%Y")
    else
      date_founded
    end
  end

end
