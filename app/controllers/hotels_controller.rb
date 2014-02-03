class HotelsController < ApplicationController
  before_filter :check_cache, :only=>[:results,:show]
  
  def complete
    data = api.complete(params[:filter])
    render :json => data
  end

  def search
    @search       = HotelSearch.new(params[:hotel_search])
    @search.rooms_count.times do |i|
      @search.rooms[i].adult = [HotelAdult.new] * @search.rooms[i].adults 
      @search.rooms[i].child = [HotelChild.new] * @search.rooms[i].childs 
    end
    @session_id  = Digest::MD5.hexdigest("#{@search.to_json}#{request.remote_ip}")
    lat_lng      = api.get_location(@search.city , @search.place_code,@session_id)
    
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

  def results
    check_cache
  end

  def show
    check_cache
    @id = params[:id].to_i  
  end


  private

  def check_cache
    HotelSearch.new(rooms:[HotelRoom.new(adult:[HotelAdult.new],child:HotelChild.new)])
    @session_id = params[:session_id]
    @results    = Rails.cache.read("hotels_search_result_"+@session_id)
    @search     = Rails.cache.read("hotels_search_query_" +@session_id)
    redirect_to :root if @results.nil? or @search.nil? 
  end

  def filter
    HotelSearch.new
    begin
    @search = Rails.cache.read("hotels_search_query_"+params[:session_id])
    search = @search.to_api_hash
	    params[:filter].each_pair do |k,v|
	search[:"#{k}"] = v
    end

    #search = @search.to_api_hash.merge!(params[:filter])
    api.hotels_list(search,Digest::MD5.hexdigest("#{params[:session_id]}#{request.remote_ip}") )
    result      = api.hotel_list
    if api.error.nil? and result.size > 0
      @results   = {:result=>result}
      @interval  = (@search.departure - @search.arrival).to_i
      crate_map_baloons api.hotel_list, params[:session_id] , @interval
      data = render_to_string :partial => "hotels/mustache/list"
	Rails.cache.write("hotels_search_result_"+params[:session_id], {:total=>api.total,
	:result=>result,:prices=>api.prices,:key=>api.cacheKey,:location=>api.cacheLocation}, :expires_in => 1.hour)
      json = {:status=>"success",:success=>true, :data=>data, :key => api.cacheKey, :location => api.cacheLocation}
    else
      text = api.error[:text] rescue text = I18n.t('hotels.default_error')
      json = {:status => 'success', :success=>false, :text =>text}
    end
    render :json =>json
	rescue
	      if request.xhr?
		      text = api.error[:text] rescue text = I18n.t('hotels.session_error')
		      render :json => {:status => 'fatal', :text =>text}
	      else
		redirect_to hotels_search_path
	      end
	end
    
  end
  
  def info 

    HotelSearch.new
    @session_id  = params[:session_id]
   # @phone_codes = v_api.phone_codes.map{ |p| ["+"+p[:country_phone], "+"+p[:country_phone]] }
    @search      = Rails.cache.read("hotels_search_query_"+@session_id)
    @interval    = (@search.departure - @search.arrival).to_i < 5 ? 5 : (@search.departure - @search.arrival).to_i
    #@countries   = v_api.countries_list.map { |c| [c[:name], c[:code]] }
    id           = params[:id]
    @id          = id
    result       = Rails.cache.read("hotels_search_result_info_"+id)
    @hotel       = result[:hotel]
    @rooms       = result[:rooms].sort_by{|room| room[:price].to_f}  
    user        = logged_in? ? current_user : User.new(:phone_code => "+38")
    @booking    = HotelsBooking.new(:user=>user,:rooms=>@search.rooms,:country=>"UA")
    session[:booking_path] = "hotels"
   rescue
    redirect_to hotels_path
  end


  def prepare
    @session_id  = params[:session_id]
    @session_id  = params[:session_id]
    @search      = Rails.cache.read("hotels_search_query_"+@session_id)
    @interval    = (@search.departure - @search.arrival).to_i < 5 ? 5 : (@search.departure - @search.arrival).to_i
    id           = params[:id]
    result       = Rails.cache.read("hotels_search_result_info_"+id)
    @hotel       = result[:hotel]
    @rooms       = result[:rooms].sort_by{|room| room[:price].to_f}
    user        = logged_in? ? current_user : User.new(:phone_code => "+38")
    @booking    = HotelsBooking.new(:user=>user,:rooms=>@search.rooms)
    session[:booking_path] = "hotels"
    render :json => {:status=>"success",:payment_form => render_to_string(:partial => 'hotels/book', :locals => {:session_id => @session_id,:id=>id})}
  end

  def booking
    HotelSearch.new
    @booking     = HotelsBooking.new(params[:hotels_booking])
    @session_id  = params[:hotels_booking][:session_id]
    @search      = Rails.cache.read("hotels_search_query_"+@session_id)
    result       = Rails.cache.read("hotels_search_result_info_"+@booking.hotel_id)

    @search.rooms_count.times do |i|
      @booking.rooms  << HotelRoom.new(:adult => HotelAdult.new ,:child=>HotelChild.new)
    end
    
    @hotel       = result[:hotel]
    @rooms       = result[:rooms].sort_by{|room| room[:price].to_f}  
    @booking.image = @hotel[:images].first[:big]
    Rails.cache.write("hotels_booking_#{current_user.id}_"+@session_id, @booking , :expires_in => 30.minutes)
   rescue
    redirect_to hotels_path
  end
  
  def prepare_pay
    @session_id = params[:hotels_booking][:session_id]
    booking     = HotelsBooking.new(params[:hotels_booking])
    @search     = Rails.cache.read("hotels_search_query_"+@session_id)
    booking.rooms.size.times do |i|
      booking.rooms[i].adult = HotelAdult.new(params[:hotels_booking][:rooms_attributes][:"#{i}"][:adult_attributes]["0"])
      #booking.rooms[i].child = HotelAdult.new(params[:hotels_booking][:rooms_attributes][:"#{i}"][:child_attributes]["0"])
      booking.rooms[i].childs = @search.rooms[i].childs
    end
    Rails.cache.write("hotels_booking_#{current_user.id}_"+@session_id, booking , :expires_in => 30.minutes)
    render :json => {:payment_form => render_to_string(:partial => 'hotels/book', :locals => {:session_id => @session_id,:id=>booking.hotel_id})}
  end

  def pay 
    booking = HotelsBooking.new(params[:hotels_booking])
    HotelSearch.new
    Rails.cache.write("hotels_booking_#{current_user.id}_"+booking.session_id, booking , :expires_in => 30.minutes)
    @card        = HotelsBookingCard.new(:session_id=>booking.session_id)
    @booking     = booking
    @search      = Rails.cache.read("hotels_search_query_"+booking.session_id)
    @payments    = api.get_payments Digest::MD5.hexdigest("#{booking.session_id}#{request.remote_ip}")  
    result       = Rails.cache.read("hotels_search_result_info_"+booking.hotel_id)
    @hotel       = result[:hotel]
    
    @countries   = Country.all.map(&:to_nationaliti_list)
    @codes       = Country.get_phones
    @current_code= Country.find_by_code($country_code).country_phone
    @rooms       = []
    result[:rooms].each{|room| @rooms << room if room[:code].to_i == booking.room_type.to_i and room[:price].to_f == booking.chargeable_rate.to_f }.first()
    redirect_to hotels_path  if @search.nil? || !@rooms.any?
    rescue 
      redirect_to hotels_path
  end
  
  def create_booking
    json = {:success=>true}
    HotelsBooking.new
    HotelRoom.new
    HotelAdult.new
    card  = HotelsBookingCard.new(params[:hotels_booking_card])
    session_id = card.session_id
    @booking    = Rails.cache.read("hotels_booking_#{current_user.id}_#{session_id}")
    @booking.card = card
    @booking.user = current_user
    data = api.book @booking.to_api_hash ,Digest::MD5.hexdigest("#{session_id}#{request.remote_ip}")  
    json = api.error.nil? ? json : {:success=>false,:msg=>api.error[:text]}
    write_booking data if api.error.nil?
    ensure
      render :json => json
  end

  def write_booking data
    data.merge!({:user_id=>current_user.id})
    rooms_data = data[:rooms_data]
    data.reject!{ |k| k == :rooms_data }
    data.merge!({:img_url=>@booking.image})
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
    #sms_api.generate_send_xml("#{current_user.phone_code}#{current_user.phone}",I18n.t("hotels.sms_description", :locator => booking.reservation_id))
    #sms_api.send_sms()
  end
  
  def get_left_block
    id   = params[:id].to_i
    html = render_to_string :partial => "hotels/mustache/resume_block"
    render :json => {:status => 'success' , :html => html}
  end
  
  def get_hotel_info
    HotelSearch.new
	begin
    session_id = params[:session_id]
    id         = params[:id]
    @search    = Rails.cache.read("hotels_search_query_"+session_id)
    @interval  = (@search.departure - @search.arrival).to_i < 5 ? 5 : (@search.departure - @search.arrival).to_i
    @interval_true = (@search.departure - @search.arrival).to_i
    data = {:hotelId=>id,:includeDetails=>true,:includeRoomImages=>true}
    data.merge!(@search.to_api_hash) 
    hotel_info = api.hotel_info({:hotelId=>id,:options=>0},Digest::MD5.hexdigest("#{session_id}#{request.remote_ip}") )
    hotel_img  = api.get_images({:hotelId=>id},Digest::MD5.hexdigest("#{session_id}#{request.remote_ip}"))
    rooms_info = api.hotel_rooms_info data , @interval,Digest::MD5.hexdigest("#{session_id}#{request.remote_ip}")  
    result  = {:hotel=>hotel_info,:rooms=>rooms_info,:images=>hotel_img}

    if api.error.nil?
      Rails.cache.write("hotels_search_result_info_"+id, result , :expires_in => 1.hour)
      price = rooms_info[0][:price].nil? ? (rooms_info[0][:max_price].to_i * @interval) : rooms_info[0][:price]
      hotel_info.merge!({:price=>price,:image=>hotel_info[:images][0][:thumb]})
      if request.xhr?
        render :json => {:success=>true , :url_ => "/hotels/info?session_id=#{params[:session_id]}&id=#{id}#description"  }
      else
        redirect_to "/hotels/info?session_id=#{params[:session_id]}&id=#{id}#description"
      end
    else
      text = api.error[:text] rescue text = I18n.t('hotels.default_error')
      render :json => {:success => false, :text =>text}
    end
	rescue
	      if request.xhr?
		      text = api.error[:text] rescue text = I18n.t('hotels.session_error')
		      render :json => {:success => false, :text =>text}
	      else
		      redirect_to hotels_search_path
	      end
	end
    
  end
  
  # def results
  #   HotelSearch.new
  #   session_id = params[:session_id]
  #   @results   = Rails.cache.read("hotels_search_result_"+session_id)
  #   @search    = Rails.cache.read("hotels_search_query_"+session_id)
  #   @interval  = (@search.departure - @search.arrival).to_i unless  @results.nil? or @search.nil?
  #   @types     = I18n.t('hotels.hotel_types')
  #   @ament     = I18n.t('hotels.amenities')
  #   redirect_to hotels_search_path if @results.nil? or @search.nil?
    
  # end
  
  def get_ballons
    session_id = params[:session_id]
    list       = params[:ids]
    result     = {}
    unless list.nil?
      list.each do |item|
        result.merge!({:"#{item}" =>  Rails.cache.read("hotels_baloon_#{item}_#{session_id}")})
      end
    end

    render :json => {:data=>result , :success=>false}
  end
  
  def load_hotels
    key      = CGI::unescape params[:key]
    location = CGI::unescape params[:location]
   
    session_id = params[:session_id]
    unless location  == "null" or location == ""
      api.hotel_list_pagination(key,location,Digest::MD5.hexdigest("#{session_id}#{request.remote_ip}"))
      @results   = {:result=>api.hotel_list}
      @search    = Rails.cache.read("hotels_search_query_"+session_id)
      @interval  = (@search.departure - @search.arrival).to_i
      crate_map_baloons api.hotel_list, session_id , @interval
      data = render_to_string :partial => "hotels/mustache/list"
      json = {:status=>"success",:success=>true, :data=>data, :key => api.cacheKey, :location => api.cacheLocation}
    else
      json = {:status=>"success" , :success=>false}
    end
    rescue
      json = {:status=>"success" , :success=>false}
    ensure
      render :json => json
  end
  
  
  
  private 
  
  def crate_map_baloons list , session_id , interval , pay = false , rooms = []

    list.each do |hotel|
      html =  render_to_string(:partial => 'hotels/mustache/map_balloon', :locals => {:rooms=>rooms,:pay=>pay,:session_id => session_id,:@hotel=>hotel,:interval=>interval})
      if Rails.cache.read("hotels_baloon_#{hotel[:id]}_#{session_id}").nil? or pay
        Rails.cache.write("hotels_baloon_#{hotel[:id]}_#{session_id}", html , :expires_in => 1.hour)
      end
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
