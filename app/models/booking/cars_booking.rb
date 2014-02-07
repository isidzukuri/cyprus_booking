class CarsBooking


  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :vehicle_id
  attribute :car_name
  attribute :protect,:default=>0
  attribute :protect_price
  attribute :car_price
  attribute :flight_number
  attribute :flight_presense
  attribute :comment
  attribute :image
  attribute :base_price
  attribute :base_currency
  attribute :rules_agrement
  nested_attribute :driver, :class_name => "Driver"
  nested_attribute :user, :class_name => "User"
  nested_attribute :pick_up,   :class_name => "CarsLocation"
  nested_attribute :dropp_off, :class_name => "CarsLocation"
  nested_attribute :extras, :class_name => "CarsExtras"
  validates_associated :user , :extras , :pick_up ,:dropp_off
   

end
