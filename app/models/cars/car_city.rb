class CarCity < ActiveRecord::Base
  has_many :car_city_locations
  attr_accessible :country_id, :lang, :name, :lat, :lng,:name_ru,:name_en

  def to_map
  	{
  		lat:self.lat,
  		lng:self.lng,
  		id:self.id,
  		name:self.name,
  	}
  end
end
