class Card


  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :holder_first_name
  attribute :holder_last_name
  attribute :card_type
  attribute :number
  attribute :cvv
  attribute :exp_month
  attribute :exp_year


   

end
