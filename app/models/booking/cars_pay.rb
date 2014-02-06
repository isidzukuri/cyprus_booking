class CarsPay
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations
  
  attribute :card_type ,:type =>Integer
  attribute :card_number ,:type =>Integer
  attribute :ccv ,:type =>Integer
  attribute :expiration_date
  attribute :expiration_year
  attribute :expiration_month
  attribute :card_holder
  attribute :session_id
  attribute :n_0
  attribute :n_1
  attribute :n_2
  attribute :n_3


  def expiration_year
    self.expiration_date.nil? ? nil : self.expiration_date.split("/").last
  end

  def expiration_month
   self.expiration_date.nil? ? nil : self.expiration_date.split("/").first
  end

  def card_number
    [self.n_0,self.n_1,self.n_2,self.n_3].join("")
  end
end