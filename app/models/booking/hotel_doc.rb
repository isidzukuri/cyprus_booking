class HotelDoc < ActiveRecord::Base

  belongs_to :hotel_booking_payed 
  attr_accessible :hotel_booking_payed_id, :adult, :bed_type, :bed_type_desc, :child, :conf_number, :first_name, :last_name, :smoking_pref ,:canceled
end
