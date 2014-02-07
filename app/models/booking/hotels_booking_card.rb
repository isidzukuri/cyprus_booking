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

  attribute :n_0
  attribute :n_1
  attribute :n_2
  attribute :n_3



  def card_number
    [self.n_0,self.n_1,self.n_2,self.n_3].join("")
  end
end
