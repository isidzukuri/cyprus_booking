class Hotel < ActiveRecord::Base
   belongs_to :hotel_location
  attr_accessible :image_url,:hotel_location_id, :low_rate,:address, :check_in, :check_out, :currency, :hight_rate, :hotel_id, :lat, :lng, :low_rate, :name, :stars
end
