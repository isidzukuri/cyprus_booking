class Traveler < ActiveRecord::Base
  attr_accessible :apartment_booking_id, :email, :gender, :is_child, :name
  belongs_to :apartment_booking
end
