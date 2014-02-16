class CarCityLocation < ActiveRecord::Base
  attr_accessible :car_city_id, :country_id, :lang, :location_id, :name,:lat, :lng
end
