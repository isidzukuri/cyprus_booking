class Hotel < ActiveRecord::Base
  attr_accessible :address, :check_in, :check_out, :currency, :hight_rate, :hotel_id, :lat, :lng, :low_rate, :name, :stars
end
