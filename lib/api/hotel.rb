
class Api::Hotel
  
  attr_reader :error , :hotel_list ,:prices ,:cacheKey ,:cacheLocation ,:total
  
  def initialize(host,cid,ip,key,seacrh_url)
    @uri      = host.to_uri()
    @error    = nil
    @defaults = {
            :cid               => cid,
            :apiKey            => key,
            :customerIpAddress => ip,
            :customerUserAgent => "Mozilla",
            :locale            => "ru_RU",
            :currencyCode      => "EUR",
            :minorRev          => 8
    }
    @places_search_url = "http://lookup.hotels.com/1/suggest/v1/json".to_uri()
    @google_url        = Settings.google_api.geocoder_url.to_uri()
    @hotel_list        = []
    @prices            = []
  end
  
 
  

  def complete(term)
    result = []
    data     = @places_search_url.get({:locale=>"ru_RU",:query=>CGI::escape(term)}).deserialise
    data["suggestions"].each do |item|
      item["entities"].each do |i|
        result << {:value => i["name"] ,:code => "#{i['latitude']}|#{i['longitude']}"}
      end
    end
    ensure
      return result
  end
    
  
  def book booking ,session_i
    uri = Settings.hotels_api.book_host.to_uri()
    @defaults[:minorRev] = 20
    data   = JSON.parse(uri['res'].post_form(@defaults.merge({:customerSessionId => session_id(session_i)}).merge(booking)).body).with_indifferent_access
    p @defaults.merge({:customerSessionId => session_id(session_i)}).merge(booking)
    p data
    parse_error data , "HotelRoomReservationResponse"
    return unless @error.nil?
    parse_booking data[:HotelRoomReservationResponse]
  end
  
  def cancel_book cancel 
    data   = JSON.parse(@uri['cancel'].get(@defaults.merge(cancel)).body).with_indifferent_access
    parse_error data , "HotelRoomCancellationResponse"
    return unless @error.nil?
    parse_cancel_book data[:HotelRoomCancellationResponse]
  end
  
  
  def hotels_list search,session_id
    lat_lng = search.delete(:destinationId).split("|")
    search.merge!(:latitude=>lat_lng.first, :longitude=>lat_lng.last)
    data   = JSON.parse(@uri['list'].get(@defaults.merge(search)).body).with_indifferent_access
    parse_error data , "HotelListResponse"
    return unless @error.nil?
    parse_hotels_list data ,session_id
  end
  
  def hotel_list_pagination cacheKey ,cacheLocation ,session_i
    data   = JSON.parse(@uri['list'].get(@defaults.merge({:customerSessionId => session_id(session_i)}).merge({:cacheKey => cacheKey , :cacheLocation => cacheLocation})).body).with_indifferent_access
    parse_error data , "HotelListResponse"
    return unless @error.nil?
    parse_hotels_list data
  end
  
  
  
  def hotel_info search ,session_i
    data   = JSON.parse(@uri['info'].get(@defaults.merge({:customerSessionId => session_id(session_i)}).merge(search)).body).with_indifferent_access
    parse_error data ,"HotelInformationResponse"
    return unless @error.nil?
    parse_hotel_info data[:HotelInformationResponse]
  end
  
  def get_images search ,session_i
    data   = JSON.parse(@uri['roomImages'].get(@defaults.merge({:customerSessionId => session_id(session_i)}).merge(search)).body).with_indifferent_access
    parse_error data ,"HotelRoomImageResponse"
     unless @error.nil?
       @error = nil
       return []
     else
       parse_hotel_images data[:HotelRoomImageResponse].with_indifferent_access
     end
  end
  
  def hotel_rooms_info search ,interval ,session_i
    data   = JSON.parse(@uri['avail'].get(@defaults.merge({:customerSessionId => session_id(session_i)}).merge(search)).body).with_indifferent_access
    parse_error data ,"HotelRoomAvailabilityResponse"
    return unless @error.nil?
    parse_hotel_rooms_info data[:HotelRoomAvailabilityResponse] , interval
  end
  
  def get_location(address,code,session_i)
    locations = {"lat"=>0 , "lng"=>0}
    hotel_loc = ::HotelLocation.find_by_code(code)
    if hotel_loc.nil?
      data = @google_url.get(:address => address,:sensor=>false).deserialise.with_indifferent_access[:GeocodeResponse]
      if data[:status] == "OK"
        data = data[:result].kind_of?(Array) ? data[:result][0][:geometry][:location] : data[:result][:geometry][:location]
        locations.merge!(data)
        ::HotelLocation.create(:code => code , :name => address , :lat => locations["lat"], :lng => locations["lng"])
      end
    else
      locations.merge!("lat" => hotel_loc.lat, "lng" => hotel_loc.lng).with_indifferent_access
    end
    ensure
      locations.with_indifferent_access
  end
  
  
  def get_trip_advisor_block id
    content = Rails.cache.read("hotel_advisor_#{id}")
    if content.nil?
      defaults = {
        :partnerId => Settings.hotels_api.trip_advisor_key,
        :lang      => "ru",
        :display   => true
      }
      url      = Settings.hotels_api.trip_advisor_url.to_uri()
      content  = url.get(defaults.merge!(:locationId=>id)).body.force_encoding("UTF-8")
      Rails.cache.write("hotel_advisor_#{id}", content , :expires_in => 1.month)
    end
    content
  end
  
  
  def get_payments session_i
    data   = JSON.parse(@uri['paymentInfo'].get(@defaults.merge({:customerSessionId => session_id(session_i)})).body).with_indifferent_access
    parse_error data ,"HotelPaymentResponse"
    return [] unless @error.nil?
    result = []
    data[:HotelPaymentResponse][:PaymentType].each{|item| result<<[item[:name],item[:code]]}
    result
  end
  
  private 
  
  def set_session key ,s_key
    Rails.cache.write(:"ses_#{s_key}","#{key}",:expires_in => 1.hour)
  end

  def session_id s_key
    Rails.cache.read("ses_#{s_key}")
  end
  
  def parse_hotels_list input , sess = false
    image_url = "http://images.travelnow.com"
    result    = []
    @cacheKey  = nil
    @cacheLocation = nil
    if sess != false
      p "="*100
      set_session input[:HotelListResponse][:customerSessionId] , sess
    end
    if input[:HotelListResponse][:moreResultsAvailable]
      @cacheKey      = input[:HotelListResponse][:cacheKey]
      @cacheLocation = input[:HotelListResponse][:cacheLocation]
    end
    hotels = input[:HotelListResponse][:HotelList][:HotelSummary].kind_of?(Array) ? input[:HotelListResponse][:HotelList][:HotelSummary] : [input[:HotelListResponse][:HotelList][:HotelSummary]]
      hotels.each do |hotel|
      next if hotel.nil?
      hotel[:RoomRateDetailsList] = {:RoomRateDetails=>{:promoDescription=>nil,:ValueAdds=>nil,:currentAllotment=>10,:RateInfos=>{:RateInfo=>{:@promo=>false,:ChargeableRateInfo=>{:@averageBaseRate =>nil ,:@total=>nil,:@currencyCode=>nil},:ConvertedRateInfo=>{:@averageBaseRate =>nil ,:@total=>nil,:@currencyCode=>nil}}}}} if hotel[:RoomRateDetailsList].nil?
      hotel[:shortDescription]    = "" if hotel[:shortDescription].nil?
      price_block = hotel[:RoomRateDetailsList][:RoomRateDetails][:RateInfos][:RateInfo].has_key?(:ConvertedRateInfo) ? hotel[:RoomRateDetailsList][:RoomRateDetails][:RateInfos][:RateInfo][:ConvertedRateInfo] : hotel[:RoomRateDetailsList][:RoomRateDetails][:RateInfos][:RateInfo][:ChargeableRateInfo]
      next if price_block[:@total].nil?
        adv = nil#get_trip_advisor_block(hotel[:hotelId])
        item = {
        :id               => hotel[:hotelId],
        :name             => hotel[:name],
        :address          => hotel[:address1],
        :distance         => hotel[:proximityDistance],
        :stars            => hotel[:hotelRating],
        :hotel_type       => hotel[:propertyCategory],
        :c_rating         => hotel[:confidenceRating],
        :trip_adv_rating  => hotel[:tripAdvisorRating],
        :trip_adv_reviews => hotel[:tripAdvisorReviewCount],
        :loc_desc         => hotel[:locationDescription],
        :desc             => hotel[:shortDescription],
        :image            => image_url+hotel[:thumbNailUrl],
        :price            => price_block[:@total].to_i,
        :avg_price        => price_block[:@averageBaseRate],
        :tax              => price_block[:@surchargeTotal].nil? ? 0 : price_block[:@surchargeTotal],
        :currency         => price_block[:@currencyCode],
        :promo            => hotel[:RoomRateDetailsList][:RoomRateDetails][:promoDescription].nil? ? nil : hotel[:RoomRateDetailsList][:RoomRateDetails][:promoDescription],
        :low_avability    => hotel[:RoomRateDetailsList][:RoomRateDetails][:currentAllotment].to_i  <= 3 ? hotel[:RoomRateDetailsList][:RoomRateDetails][:currentAllotment] : nil ,
        :price_desc       => hotel[:RoomRateDetailsList][:RoomRateDetails][:RateInfos][:RateInfo][:ChargeableRateInfo].has_key?(:Surcharges) ?  true : false,
        :lat              => hotel[:latitude],
        :lng              => hotel[:longitude],
        :highRate         => hotel[:highRate],
        :h_currency       => hotel[:rateCurrencyCode],
        :advisor_id       => adv.nil? ? nil : adv.match(/locationId=(\d?)+&/).to_s.match(/\d+/).to_s,
        :advisor_url      => hotel[:tripAdvisorRatingUrl],
        :avg_price        => price_block[:@averageBaseRate].to_i,
        :promo_price      => hotel[:RoomRateDetailsList][:RoomRateDetails][:RateInfos][:RateInfo][:@promo] == "true" ? array_chek(price_block[:NightlyRatesPerRoom][:NightlyRate])[0][:@rate] : nil,
        :city             => hotel[:city],
        :zip              => hotel[:postalCode]
      }
      item.merge!( {:options   => array_chek(hotel[:RoomRateDetailsList][:RoomRateDetails][:ValueAdds][:ValueAdd]).collect{|i| i["description"]}}) unless hotel[:RoomRateDetailsList][:RoomRateDetails][:ValueAdds].nil?
      @hotel_list << item
      @prices <<  price_block[:@total].to_i
    end
    @total = input[:HotelListResponse][:HotelList][:@activePropertyCount]
  end


def parse_hotel_info input
  base    = input[:HotelSummary]
  details = input[:HotelDetails]
  images  = []
  input[:HotelImages][:HotelImage]= [] if input[:HotelImages][:HotelImage].nil?
  input[:HotelImages][:HotelImage].each do |img|
    images << {:thumb=>img[:thumbnailUrl],:big=>img[:url]}
  end
  input[:PropertyAmenities] = {:PropertyAmenity=>[]} if input[:PropertyAmenities].nil?
  hotel = {
    :id               => base[:hotelId],
    :name             => base[:name],
    :address          => base[:address1],
    :city             => base[:city],
    :postal           => base[:postalCode],
    :hotel_type       => base[:propertyCategory],
    :stars            => base[:hotelRating],
    :trip_adv_rating  => base[:tripAdvisorRating],
    :loc_desc         => base[:locationDescription],
    :lat              => base[:latitude],
    :lng              => base[:longitude],
    :desc             => details[:propertyDescription],
    :images           => images,
    :area_info        => details[:areaInformation],
    :amenities        => array_chek(input[:PropertyAmenities][:PropertyAmenity]),
    :rooms_info       => details[:roomInformation],
    :parking          => details[:drivingDirections],
    :chek_in          => details[:checkInInstructions],
  }

  hotel
end

def parse_hotel_images input
  input[:RoomImages][:RoomImage]
end


def parse_hotel_rooms_info input , interval
  result = []
  input[:HotelRoomResponse] = array_chek input[:HotelRoomResponse]
  input[:HotelRoomResponse].each do |room|
      room[:ValueAdds] = {:ValueAdd=>[]} if room[:ValueAdds].nil?
      room[:ValueAdds][:ValueAdd] = array_chek room[:ValueAdds][:ValueAdd]
      price_block = room[:RateInfos][:RateInfo].has_key?(:ConvertedRateInfo) ? room[:RateInfos][:RateInfo][:ConvertedRateInfo] : room[:RateInfos][:RateInfo][:ChargeableRateInfo]

        taxes =  room[:RateInfos][:RateInfo][:ChargeableRateInfo].has_key?(:Surcharges) ? array_chek(room[:RateInfos][:RateInfo][:ChargeableRateInfo][:Surcharges][:Surcharge]) : nil
        unless taxes.nil?
          tax = ""
          taxes.each do |item| 
            tax = item[:@amount] if item[:@type] == "TaxAndServiceFee"
          end
          taxes = tax
        end
        swef = array_chek room[:RateInfos][:RateInfo][:RoomGroup][:Room]

        price_block[:NightlyRatesPerRoom] = {:NightlyRate=>[]} if price_block.nil? or price_block[:NightlyRatesPerRoom].nil?
   item = { 
        :code      => room[:roomTypeCode],
        :rate_code => room[:rateCode],
        :refunable => !room[:nonRefundable],
        :avability => room[:currentAllotment],
        :max_adt   => room[:quotedOccupancy],
        :smoke     => room[:smokingPreferences],
        :type      => room[:rateDescription],
        :image     => room[:RoomImages].nil? ? nil : room[:RoomImages][:RoomImage][:url],
        :avail     => room[:currentAllotment],
        :options   => room[:ValueAdds][:ValueAdd].collect{|i| i["description"]},
        :price     => price_block[:@nightlyRateTotal].to_f,
        :currency  => price_block[:@currencyCode],
        :total_prc => room[:RateInfos][:RateInfo][:ChargeableRateInfo].has_key?(:Surcharges) ?  true : false,
        :taxes     => taxes,
        :cancel    => room[:cancellationPolicy],
        :prices    => array_chek(price_block[:NightlyRatesPerRoom][:NightlyRate]),
        :max_price => price_block[:@maxNightlyRate].to_i,
        :avg_price => price_block[:@averageRate].to_i,
        :s_type    => room[:supplierType],
        :rate_key  => input[:rateKey],
  :tax       => price_block[:@surchargeTotal].nil? ? 2.to_f : price_block[:@surchargeTotal].to_f

      }
  item[:price] = (item[:price] + item[:tax]).to_f
  result << item
  end

  result
end


def parse_error input,type
  if input[:"#{type}"].has_key? :EanWsError
    @error = {:text => input[:"#{type}"][:EanWsError][:presentationMessage] , :type=>"fatal"}
  end
end



def array_chek(array)
  array = array.kind_of?(Array) ? array : [array]
end


 def parse_booking input
    rate_info = array_chek input[:RateInfos][:RateInfo]
    room = array_chek rate_info[0][:RoomGroup][:Room]
    price_block = rate_info[0][:ConvertedRateInfo].nil? ? rate_info[0][:ChargeableRateInfo] : rate_info[0][:ConvertedRateInfo]
    
    dep = input[:departureDate].split("/")
    dep = dep[1] + "-" + dep[0] + "-" + dep[2]
    arr = input[:arrivalDate].split("/")
    arr = arr[1] + "-" + arr[0] + "-" + arr[2]
    interval =  (DateTime.parse(dep) - DateTime.parse(arr)).to_i
    adt = 0
    chd = 0
    names = ""
    rooms_data = array_chek rate_info[0][:RoomGroup][:Room]
    rooms_data.each do |i|
      adt += i[:numberOfAdults].to_i
      chd += i[:numberOfChildren].to_i
      names += "#{i[:firstName]} #{i[:lastName]} ,"
    end


    input[:cancellationPolicy] = input[:cancellationPolicy].nil? ? rate_info[0][:cancellationPolicy] : input[:cancellationPolicy]
    input[:nonRefundable] = input[:nonRefundable].nil? ? rate_info[0][:nonRefundable] : input[:nonRefundable]
    input[:confirmationNumbers] = input[:confirmationNumbers].kind_of?(Array) ? input[:confirmationNumbers].join(",") : input[:confirmationNumbers]

    data = {

      :sesion_id => input[:customerSessionId],
      :arrival_date => arr,
      :cancel_policy => input[:cancellationPolicy],
      :checkin_inst => input[:checkInInstructions],
      :conf_numbers => input[:confirmationNumbers], 
      :departure_date => dep, 
      :hotel_address => input[:hotelCountryCode].to_s + " " + input[:hotelCity].to_s + " " + input[:hotelAddress].to_s + " " +input[:hotelPostalCode].to_s, 
      :hotel_name => input[:hotelName], 
      :non_refunable => input[:nonRefundable], 
      :occupancy_pre_room => input[:rateOccupancyPerRoom], 
      :price_per_night => (price_block[:@total].to_f / interval.to_f).to_f.round(2), 
      :reservation_exist => input[:existingItinerary], 
      :reservation_id => input[:itineraryId], 
      :room_desc => input[:roomDescription], 
      :rooms_data => rooms_data,
      :rooms => input[:numberOfRoomsBooked], 
      :base_currency => price_block[:@currencyCode],
      :s_type => input[:supplierType], 
      :status => input[:reservationStatusCode], 
      :total_price => price_block[:@total], 
      :with_confirmation => input[:processedWithConfirmation]


    }



 end


 def parse_cancel_book input
  input[:cancellationNumber]
 end


  
end
