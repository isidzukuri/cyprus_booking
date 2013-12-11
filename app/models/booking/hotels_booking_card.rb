class  HotelsBookingCard


  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations
  
  attribute :address
  attribute :card_type
  attribute :card_number
  attribute :cvv
  attribute :exp_date 
  attribute :card_holder
  attribute :zip_code
  attribute :phone_code
  attribute :phone
  attribute :country
  
  attribute :session_id

   

end
