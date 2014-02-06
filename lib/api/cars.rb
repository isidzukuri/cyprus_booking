
class Api::Cars
  
  attr_reader :error
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  def initialize(host,user,pass,ip)
    @uri      = host.to_uri()
    @error    = nil
    @user     = user
    @pass     = pass
    @ip       = ip
    @prefered = {:preflang =>'ru' , :prefcurr=>'EUR'}
    @xml      = Builder::XmlMarkup.new
  end

  
  def get_county_list 
    res =
      @uri.get(:xml=>country_list_request)
    parse_errors res , "PickUpCountryListRS"
    return @error unless @error.nil?
    refresh
    parse_country_list res
  end
  
  def get_city_list country
    res =
      @uri.get(:xml=>city_list_request(country))
    parse_errors res , "PickUpCityListRS"
    return @error unless @error.nil?
    refresh
    parse_city_list res
  end
  
  def get_location_list country , city
    res =
      @uri.get(:xml=>location_list_request(country,city))
    parse_errors res , "PickUpLocationListRS"
    return @error unless @error.nil?
    refresh
    parse_location_list res
  end
  
  def get_dropp_off_country_list location_id
    res =
      @uri.get(:xml=>dropp_off_country_list_request(location_id))
    parse_errors res , "DropOffCountryListRS"
    return @error unless @error.nil?
    refresh
    parse_dropp_off_country_list res
  end
  
  def get_dropp_off_city_list location_id , country
    res =
      @uri.get(:xml=>dropp_off_city_list_request(location_id,country))
    parse_errors res , "DropOffCityListRS"
    return @error unless @error.nil?
    refresh
    parse_dropp_off_city_list res
  end
  
  def get_dropp_off_locations_list location_id , country , city
    res =
      @uri.get(:xml=>dropp_off_location_list_request(location_id,country,city))
    parse_errors res , "DropOffLocationListRS"
    return @error unless @error.nil?
    refresh
    parse_location_list res
  end
  
  def search_cars search #pick_up ,drop_off,age
    refresh
    p search_cars_request(search)
    refresh
    res =
      @uri.get(:xml=>search_cars_request(search))
    parse_errors res , "SearchRS"
    return @error unless @error.nil?
    refresh
    parse_cars_list res
  end
  
  def get_rental_terms loc_id
    res =
      @uri.get(:xml=>rental_terms_request(loc_id))
    parse_errors res , "RentalTermsRS"
    return @error unless @error.nil?
    refresh
    parse_rental_terms res
  end
  
  def get_payment_methods loc_id
    res =
      @uri.get(:xml=>payment_methods_request(loc_id))
    parse_errors res , "PaymentMethodListRS"
    return @error unless @error.nil?
    refresh
    parse_payment_methods res
  end
 
  def get_car_info car_id
    res =
      @uri.get(:xml=>car_info_request(car_id))
    parse_errors res , "VehicleInfoRS"
    return @error unless @error.nil?
    refresh
    parse_car_info res
  end  
  
  def get_car_extra car_id
    res =
      @uri.get(:xml=>car_extra_request(car_id))
    parse_errors res , "ExtrasListRS"
    return @error unless @error.nil?
    refresh
    parse_car_extra res
  end  

  def get_open_time_list location , date
    res =
      @uri.get(:xml=>open_time_list_request(location,date,"PickUpOpenTimeRQ"))
    parse_errors res , "PickUpOpenTimeRS"
    return @error unless @error.nil?
    parse_open_time_list res , "PickUpOpenTimeRS"
  end

  def get_dropp_off_open_time_list location , date
    res =
      @uri.get(:xml=>open_time_list_request(location,date ,"DropOffOpenTimeRQ"))
    parse_errors res , "DropOffOpenTimeRS"
    return @error unless @error.nil?
    parse_open_time_list res , "DropOffOpenTimeRS"
  end
  
  
  
  def get_location_info id
    res =
      @uri.get(:xml=>location_info_request(id))
    parse_errors res , "LocationInfoRS"
    return @error unless @error.nil?
    refresh
    parse_location_info res
  end

  
  def make_booking booking ,card_params

    #@uri = Settings.auto_api.secure.to_uri()
    res =
      @uri.get(:xml=>booking_request(booking,card_params))
    parse_errors res , "MakeBookingRS"
    return @error unless @error.nil?
    refresh
    parse_make_booking res
  end
  
  private
  
  # Prepare XML request
  
  def set_credential
    @xml.Credentials('username'=>@user,'password'=>@pass,'remoteIp'=>@ip)
  end
  
  def country_list_request
    result =
      @xml.PickUpCountryListRQ(@prefered){
        set_credential
      }
  end
  
  def city_list_request country
    result =
      @xml.PickUpCityListRQ(@prefered){
        set_credential
        @xml.Country(country)
      }
  end
  
  def location_list_request country,city
    result =
      @xml.PickUpLocationListRQ(@prefered){
        set_credential
        @xml.Country(country)
        @xml.City(city)
      }
  end
  
  def dropp_off_country_list_request location_id
    result =
      @xml.DropOffCountryListRQ(@prefered){
        set_credential
        @xml.Location(:id=>location_id)
      }
  end
  
  def dropp_off_city_list_request location_id,country
    result =
      @xml.DropOffCityListRQ(@prefered){
        set_credential
        @xml.Location(:id=>location_id)
        @xml.Country(country)
      }
  end
  
  def dropp_off_location_list_request location_id,country,city
    result =
      @xml.DropOffLocationListRQ(@prefered){
        set_credential
        @xml.Location(:id=>location_id)
        @xml.Country(country)
        @xml.City(city)
      }
  end
  
  # pick and drop format ={:location_id=>4178,:date=>"2012-9-15-11-30"}
  
  def search_cars_request search

    pick_date = search.pick_up.date.strftime("%d.%m.%Y").split('.')
    drop_date = search.dropp_off.date.strftime("%d.%m.%Y").split('.')
    pick_time = search.pick_up.time.split('-')
    drop_time = search.dropp_off.time.split('-')
    pick_lock = search.pick_up.location
    drop_lock = search.same_place.to_i == 1 ? search.pick_up.location :  search.dropp_off.location
    age = search.confirm_age.to_i == 0 ? search.driver_age : 30
    result =
      @xml.SearchRQ(@prefered){
        set_credential
        @xml.PickUp{
            @xml.Location(:id=>pick_lock)
            @xml.Date(:year=>pick_date[2],:month=>pick_date[1],:day=>pick_date[0],:hour=>pick_time[0],:minute=>pick_time[1])
        }
        @xml.DropOff{
            @xml.Location(:id=>drop_lock)
            @xml.Date(:year=>drop_date[2],:month=>drop_date[1],:day=>drop_date[0],:hour=>drop_time[0],:minute=>drop_time[1])
        }
        @xml.DriverAge(age)
      }
  end
  
  def rental_terms_request location_id
    result =
      @xml.RentalTermsRQ(@prefered){
        set_credential
        @xml.Location(:id=>location_id)
      }
  end
  
  def payment_methods_request location_id 
    result =
      @xml.PaymentMethodListRQ(@prefered){
        set_credential
        @xml.Location(:id=>location_id)
      }
  end
  
  def car_info_request car_id
    result =
      @xml.VehicleInfoRQ(@prefered){
        set_credential
        @xml.Vehicle(:id=>car_id)
      }
  end
  
  def car_extra_request car_id
    result =
      @xml.ExtrasListRQ(@prefered){
        set_credential
        @xml.Vehicle(:id=>car_id)
      }
  end

  def location_info_request id
    result =
      @xml.LocationInfoRQ(@prefered){
        set_credential
        @xml.Location(:id=>id)
      }
  end
  
  # pick and drop format ={:location_id=>4178,:date=>"2012-9-15-11-30"}
  # extra must have UNIQUE Extras {:id=>151, :amount=>" amount of unique extra"}

  
  def booking_request booking ,card
    pick_date = booking.pick_up.date.strftime("%d.%m.%Y").split('.')
    drop_date = booking.dropp_off.date.strftime("%d.%m.%Y").split('.')
    pick_time = booking.pick_up.time.split('-')
    drop_time = booking.dropp_off.time.split('-')

    result =
      @xml.MakeBookingRQ(@prefered){
        set_credential
        @xml.Booking(){
          @xml.PickUp{
              @xml.Location(:id=>booking.pick_up.location)
              @xml.Date(:year=>pick_date[2],:month=>pick_date[1],:day=>pick_date[0],:hour=>pick_time[0],:minute=>pick_date[1])
          }
          @xml.DropOff{
              @xml.Location(:id=>booking.dropp_off.location)
              @xml.Date(:year=>drop_date[2],:month=>drop_date[1],:day=>drop_date[0],:hour=>drop_time[0],:minute=>drop_date[1])
          }
          @xml.Vehicle(:id=>booking.vehicle_id)
          @xml.ExtraList{
            booking.extras.each do |e|
              if e.count > 0
                  @xml.Extra(:id=>e.id,:amount=>e.count)
              end
            end
          }
          
          @xml.DriverInfo{
            @xml.DriverName(:title=>'Mr',:firstname=>booking.driver.name,:lastname=>booking.driver.surname)
            @xml.Email(booking.user.email)
            @xml.DriverAge((Time.now.year - booking.driver.birthday_year))
            @xml.BirthDate(:year=>booking.driver.birthday_year,:month=>booking.driver.birthday_month,:day=>booking.driver.birthday_day)
          }
          @xml.PaymentInfo(:depositPayment=>false){
            @xml.CreditCard(:type=>card.card_type){
              @xml.CardNumber(card.card_number)
              @xml.CCV2(card.ccv)
              @xml.ExpirationDate(:year=>card.expiration_year,:month=>card.expiration_month)
              @xml.CardHolder(card.card_holder)
                
            }
          }
          @xml.AdditionalInfo(){
            @xml.Comments(booking.comment)
          }
          @xml.AirlineInfo(:flightNo=>booking.flight_number) if booking.flight_presense.to_i == 0
        }
      }
      p result
      result
  end

  def open_time_list_request location,date , type
    date = date.split('.')
    if type == 'PickUpOpenTimeRQ'
      result =  
        @xml.PickUpOpenTimeRQ(@prefered){
          set_credential
          @xml.Location(:id=>location)
          @xml.Date(:year=>date[2],:month=>date[1],:day=>date[0])
        }
    else
      result =  @xml.DropOffOpenTimeRQ(@prefered){
          set_credential
          @xml.Location(:id=>location)
          @xml.Date(:year=>date[2],:month=>date[1],:day=>date[0])
        }
    end
      result
  end
  #*******************************************************#
  
  # Parse response XML lists
  # return Array
  
  def parse_country_list input
     data = input.deserialise.with_indifferent_access
    
     dd   = data[:PickUpCountryListRS][:CountryList][:Country]
     res  = data[:PickUpCountryListRS][:CountryList][:Country].map{ |m| m unless m.match(/[a-zA-Z]/) }
     res2 = dd.map{ |m| m if m.match(/[a-zA-Z]/) }
     res = (res + res2).compact
     rescue 
       @error = {:type=>'Remote',:text=>'nothing'}
       []
  end

  def parse_city_list input
     
     data = input.deserialise.with_indifferent_access
     data[:PickUpCityListRS][:CityList][:City]
     rescue 
       @error = {:type=>'Remote',:text=>'nothing'}
       []
  end
  
  def parse_location_list input
     data = input.body.to_s.scan(/<Location id='(\d+)'>(.*?)<\/Location>/)
     res = []
     data.each do |i|
       res << {:id=>i[0],:name=>i[1]}
     end
     res
     rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
  end

  def parse_dropp_off_country_list input
     data = input.deserialise.with_indifferent_access
     data[:DropOffCountryListRS][:CountryList][:Country] 
     rescue 
       @error = {:type=>'Remote',:text=>'nothing'}
       []
  end
  
  def parse_dropp_off_city_list input
     data = input.deserialise.with_indifferent_access
     data[:DropOffCityListRS][:CityList][:City]
     rescue 
       @error = {:type=>'Remote',:text=>'nothing'}
       []
  end
  
  def parse_cars_list input
    data = input.deserialise.with_indifferent_access
   
    price_data = input.body.scan(/<Price (.*?)>(.*?)<\/Price/mi).collect{|o| o[0].gsub("\r\n","").gsub("\t","").split(" ").collect{|t| Hash[*t.gsub("\"","").split("=")]}}

    data = !data[:SearchRS][:MatchList].kind_of?(String) ? data[:SearchRS][:MatchList][:Match] : [] ;
    result = []
    data.each_with_index  do |i,k|
      g = {}
      price_data[k].each{|l| g.merge!(l)}
      g.merge!(:price=>i[:Price])
      result << {
        :car_info => i[:Vehicle],
        :route    => i[:Route],
        :price    => g     
      }
    end
    result
    rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
  end
  
  def parse_rental_terms input
    result = []
    data = input.deserialise.with_indifferent_access
    data[:RentalTermsRS][:TermsList][:TermGroup].each do |t|
      result << {
        :text=>t[:Term].kind_of?(Array) ? t[:Term] : [t[:Term]],
        :type=>t[:type]
      }
    end
    result
    rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
  end
  
  def parse_payment_methods input
    result = []
    data = ActiveSupport::XmlMini.parse(input.body).with_indifferent_access
    data[:PaymentMethodListRS][:PaymentMethodList][:PaymentMethod].each do |i|
      result << {
        :name     => i[:__content__],
        :id       => i[:id],
        :type     => i[:type],
        :min_time => i[:minimumLeadTime]
      }
    end
    result
    rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
  end

  def parse_car_info input
    data = input.deserialise.with_indifferent_access
    data[:VehicleInfoRS][:Vehicle]
    rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
      
  end
  
  def parse_car_extra input
    data = ActiveSupport::XmlMini.parse(input.body).with_indifferent_access
    result = [] 
    data = data[:ExtrasListRS][:ExtraInfoList][:ExtraInfo].kind_of?(Array)   ? data[:ExtrasListRS][:ExtraInfoList][:ExtraInfo] : [data[:ExtrasListRS][:ExtraInfoList][:ExtraInfo]] 
    data.each_with_index do |i,k|
      i = i.with_indifferent_access
      result << {
        :name       => i[:Extra][:Name]['__content__'],
        :comm       => i[:Extra][:Comments],
        :id         => i[:Extra][:id],
        :available  => i[:Extra][:available],
        :currency   => i[:Price][:currency],
        :b_currency => i[:Price][:baseCurrency],
        :price      => i[:Price][:basePrice],
        :avans      => i[:Price][:prePayable],
        :max_price  => i[:Price][:maxPrice],
        :min_price  => i[:Price][:minPrice],
        :price_desc => i[:Price][:pricePerWhat],
      }
    end
    result
  end

  def parse_location_info input
    data = ActiveSupport::XmlMini.parse(input.body).with_indifferent_access
    data[:LocationInfoRS][:LocationInfo][:Address]
    rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
  end
  
  def parse_open_time_list input ,type
     data = input.deserialise.with_indifferent_access
     hours = data[:"#{type}"][:OpenTime]
     val = 24.times.map{|h| h = (h+0).to_s.size == 1 ? "0#{(h+0).to_s}-00" : "#{(h+0).to_s}-00" }
     res = []
     hours.each_char.each_with_index{|t,i| res << val[i] unless(t.to_i==0)}
     res
     rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      []
  end
  
  
  def parse_make_booking input
    p input
    data = input.deserialise.with_indifferent_access
    data = data[:MakeBookingRS][:Booking][:id]
    rescue 
      @error = {:type=>'Remote',:text=>'nothing'}
      nil
  end
  
  #*******************************************************#
  
  #Check errors 

  def parse_errors input,type
    if  !input.kind_of?(Array) && input.content_type=="text/xml"
      data = input.deserialise.with_indifferent_access
      if data.has_key? type and data[type].has_key? :Error
        @error = {:type=>'Remote',:text=>data[type][:Error][:Message]}
        @error.merge!(:id=>data[type][:Error][:id]) if data[type][:Error].has_key? :id
      elsif data.has_key? :DefaultRS
        @error = {:type=>'Local',:text=>'Wrong XML'}
      end
    elsif input.kind_of?(Array)
      @error = {:type=>'Local',:text=>'Wrong XML'}
    end
  end

  def refresh
    @xml      = Builder::XmlMarkup.new
  end
  
end