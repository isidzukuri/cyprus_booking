class  HotelsBooking


  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :hotel_id
  attribute :arrival
  attribute :departure
  attribute :supplier_type
  attribute :rate_key
  attribute :room_type
  attribute :rate_code
  attribute :chargeable_rate
  attribute :currency
  attribute :name
  attribute :city
  attribute :postal_code
  attribute :country
  attribute :state_province_code
  attribute :image
  attribute :stars
  attribute :desc
  
  attribute :session_id
  attribute :comment

  nested_attribute :rooms, :class_name => "HotelRoom"
  nested_attribute :user, :class_name  => "User"
  nested_attribute :card, :class_name  => "HotelsBookingCard"
   

  
  def to_api_hash
    hash = {}
    params = {
      :hotelId        => self.hotel_id,
      :arrivalDate    => self.departure,
      :departureDate  => self.arrival ,
      :supplierType   => self.supplier_type,
      :rateKey        => self.rate_key,
      :roomTypeCode   => self.room_type,
      :chargeableRate => self.chargeable_rate.to_f.round(2),
      :rateCode       => self.rate_code,
      
      :email          => self.user.email,
      :firstName      => Settings.in_production ? self.user.first_name  : "Test Booking",
      :lastName       => Settings.in_production ? self.user.last_name  : "Test Booking",
      :homePhone      => "#{self.user.phone_code}#{self.user.phone}",
      :workPhone      => "#{self.user.phone_code}#{self.user.phone}",
      
      
      :creditCardType            => self.card.card_type,
      :creditCardNumber          => self.card.card_number.delete(' '),
      :creditCardIdentifier      => self.card.cvv,
      :creditCardExpirationMonth => self.card.exp_date.split("/").first(),
      :creditCardExpirationYear  => "20" + self.card.exp_date.split("/").last(),
      :address1 => Settings.in_production  ? self.card.address : "travelnow",
      :city=> "none",
      :stateProvinceCode=>"none",
      :countryCode=>self.card.country,
      :postalCode=>self.card.zip_code,
      
    }
    rooms = []
    self.rooms.size.times do |i|
      k = i+1
      params.merge!({:"room#{k}"=>self.rooms[i].to_api_hash})
      params.merge!({:"room#{k}FirstName"=>self.rooms[i].adult.first_name,:"room#{k}LastName"=>self.rooms[i].adult.last_name})
    end
    
    hash = params
    
    #ensure
      return hash
    
    
  end
  
  
end
