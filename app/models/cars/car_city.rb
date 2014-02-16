class CarCity < ActiveRecord::Base
  attr_accessible :country_id, :lang, :name, :lat, :lng
  def to_map
  	{
  		lat:self.lat,
  		lng:self.lng,
  		id:self.id,
  		name:self.name,
  	}
  end
end
