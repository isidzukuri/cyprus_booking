class HotelsController < ApplicationController
  before_filter :require_login, :only=>[:booking]
  before_filter :check_cache, :only=>[:results,:show,:booking,:book,:load_hotels,:pay]
  before_filter :hotel_item_cache, :only=>[:show,:booking,:book,:pay]

  def get_map_items
    Hotel.where(citi_id:params[:id])
    
  end

  def search
    @search       = HotelSearch.new(params[:hotel_search])
    loc = HotelLocation.find(@search.city)
    @search.place_code = "#{loc.lat}|#{loc.lng}"
    @search.city = loc.name
    @search.rooms_count.times do |i|
      @search.rooms[i].adult = [HotelAdult.new] * @search.rooms[i].adults 
      @search.rooms[i].child = [HotelChild.new] * @search.rooms[i].childs 
    end
    @session_id  = ses_id
    lat_lng      = api.get_location(@search.city , @search.place_code, @session_id)
    
    api.hotels_list(@search.to_api_hash,@session_id)
    @results     = api.hotel_list
    @key         = api.cacheKey
    @location    = api.cacheLocation

    if api.error.nil? and @results.size > 0
      cookies[:last_hotels_search] = {
        :value => Marshal.dump(@search),
        :expires => 1.hour.from_now
      }
      Rails.cache.write("hotels_search_result_"+@session_id, {:total=>api.total,:result=>@results,:prices=>api.prices,:key=>@key,:location=>@location}, :expires_in => 1.hour)
      Rails.cache.write("hotels_search_query_" +@session_id,@search, :expires_in => 1.hour)
      unless params[:map_search].to_bool
        json = {success:true,map_search:params[:map_search].to_bool,url:hotels_results_path(session_id:@session_id)}
      else
        json = {success:true,map_search:params[:map_search].to_bool,data:@results.map{|h| {:id=>h[:id],:lat=>h[:lat],:lng=>h[:lng],:name=>h[:name]}}, html:render_to_string(:partial => "hotels/map_results")}
      end
    else
      text = api.error[:text] rescue text = I18n.t('hotels.default_error')
      json = {:success => false, :text =>text}
    end
    render :json => json
  end

  def complete
    data = api.complete(params[:filter])
    render :json => data
  end

  def results
  end

  def load_hotels
    key      = CGI::unescape params[:key]
    location = CGI::unescape params[:location]
    json     = {:success=>false}
    unless location == "" || location == "null"
      api.hotel_list_pagination(key,location,params[:session_id])
      data   = ""
      api.hotel_list.each do |hotel|
        data << render_to_string(partial:"hotels/result_item",:locals=>{:hotel=>hotel})
      end
      json = {:success=>true, :html=>data, :data=>{:session_id=>@session_id,:key => api.cacheKey, :location => api.cacheLocation}}
    end
  ensure
      render :json => json
  end

  def show 
    @booking = HotelsBooking.new
  end

  def booking
    @booking   = HotelsBooking.new(params[:hotels_booking])
    @room      = @result[:rooms].select{|room|  room[:code].to_i == @booking.room_type.to_i and room[:price].to_f == @booking.chargeable_rate.to_f }.first
    @countries = Country.all.map(&:to_nationaliti_list)
  end

  def book
    @booking = HotelsBooking.new(params[:hotels_booking])
    @booking.rooms.size.times do |i|
      @booking.rooms[i].adult = HotelAdult.new(params[:hotels_booking][:rooms_attributes][:"#{i}"][:adult_attributes]["0"])
      @booking.rooms[i].childs = @search.rooms[i].childs
    end
    @room    = @result[:rooms].select{|room|  room[:code].to_i == @booking.room_type.to_i and room[:price].to_f == @booking.chargeable_rate.to_f }.first
    p_meth
  end

  def pay
    json = {:success=>true}
    @booking = HotelsBooking.new(params[:hotels_booking])
    @booking.user = current_user
    data = api.book(@booking.to_api_hash ,params[:session_id])  
    if api.error.nil?
      json = write_booking(data,@booking)
    else
      json = {:success => false, :msg=> api.error[:text] }
    end
  ensure
    render :json => json
  end


  private

  def write_booking data,booking
    p @result
    data.merge!({
      :desc => @result[:hotel][:desc],
      :stars => @booking.stars,
      :img_url=>@booking.image,
      :user_id=>current_user.id,
      })
    rooms_data = data[:rooms_data]
    data.reject!{ |k| k == :rooms_data }
    booking = HotelBookingPayed.create(data)
    conf = booking.conf_numbers.split(",") rescue [booking.conf_numbers]
    rooms_data.each_with_index do |room,i|
      HotelDoc.create({
        :hotel_booking_payed_id => booking.id,
        :adult => room[:numberOfAdults],
        :child => room[:numberOfChildren],
        :first_name => room[:firstName],
        :last_name => room[:lastName],
        :bed_type => room[:bedTypeId],
        :bed_type_desc => room[:bedTypeDescription],
        :smoking_pref  => room[:smokingPreference],
        :conf_number   => conf[i]
        })
    end
    {:success=>true,:id=>booking.id}
  end

  def p_meth
    @p_meth  = Rails.cache.fetch("hotels_search_item_payments_#{@session_id}", :expires_in => 200.minutes) do
      api.get_payments(params[:session_id])
    end
  end

  def set_layout
    @body_cls = "car_page hotel_page"
  end

  def ses_id
    Digest::MD5.hexdigest("#{@search.to_json}#{request.remote_ip}")
  end

  def check_cache
    HotelSearch.new(rooms:[HotelRoom.new(adult:[HotelAdult.new],child:HotelChild.new)])
    @session_id = params[:session_id]
    @results    = Rails.cache.read("hotels_search_result_"+@session_id)
    @search     = Rails.cache.read("hotels_search_query_" +@session_id)
    redirect_to :root if @results.nil? or @search.nil? 
  end

  def hotel_item_cache
    @session_id = params[:session_id]
    @result  = Rails.cache.fetch("hotels__search_item_#{@session_id}_#{params[:id]}", :expires_in => 200.minutes) do
      data = {:hotelId=>params[:id],:includeDetails=>true,:includeRoomImages=>true}
      data.merge!(@search.to_api_hash) 
      hotel_info = api.hotel_info({:hotelId=>params[:id],:options=>0}, params[:session_id])
      hotel_img  = api.get_images({:hotelId=>params[:id]},params[:session_id])
      rooms_info = api.hotel_rooms_info data , @search.interval, params[:session_id]  
      {:hotel => hotel_info,:rooms=>rooms_info,:images=>hotel_img}
    end
  end
      
  
  def get_trip_advisor_block id
    defaults = {
      :partnerId => Settings.hotels_api.trip_advisor_key,
      :lang      => "ru",
      :display   => true
    }
    url      = Settings.hotels_api.trip_advisor_url.to_uri()
    content  = url.get(defaults.merge!(:locationId=>id)).body.force_encoding("UTF-8")
  end
  
  def api
    @api ||= Api::Hotel.new(Settings.hotels_api.host,Settings.hotels_api.cid,Settings.hotels_api.ip,Settings.hotels_api.key,Settings.hotels_api.search_url)
  end
  
end
