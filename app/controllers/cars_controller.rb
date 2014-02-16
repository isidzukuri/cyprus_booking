class CarsController < ApplicationController
  before_filter :require_login, :only=>[:booking]
  before_filter :check_cache, :only=>[:results,:show]
  

  def set_layout
    @body_cls = "car_page"
  end

  def get_map_items
    
  end


  def search
    @search  = CarsSearch.new(params[:cars_search])
    @search.dropp_off.location = @search.pick_up.location if @search.same_place == 1
    result      = api.search_cars @search 
    @session_id = Digest::MD5.hexdigest("#{@search.to_json}#{request.remote_ip}")
    cookies[:last_cars_search] = {
      :value => Marshal.dump(@search),
      :expires => 24.hours.from_now
    }
    if result.size < 1
      text = api.error.text rescue text = I18n.t('search.cars.default_error')
      render :json => {:success => false, :text =>text}
    else
      @session_id  = Digest::MD5.hexdigest("#{@search.to_json}#{request.remote_ip}")
      Rails.cache.write("auto_search_result_" + @session_id, result, :expires_in => 1.hour)
      Rails.cache.write("auto_search_query_" +@session_id,@search, :expires_in => 1.hour)
      render :json => {:success => true, :url => cars_results_path(:session_id=>@session_id)}
    end
  end

  def results
    check_cache  
  end

  def show
    check_cache
    get_car_item
    @car_extra = api.get_car_extra params[:id]
    @booking   = CarsBooking.new(:extras=>[CarsExtras.new]*@car_extra.count,:driver=>Driver.new)
    redirect_to :root if @car.nil?  
  end

  def booking
    check_cache
    get_car_item
    @booking    = CarsBooking.new params[:cars_booking]
    @booking.dropp_off  = @search.dropp_off
    @booking.pick_up    = @search.pick_up
    @booking.vehicle_id = params[:id]
    check_protect
    Rails.cache.write("auto_last_booking_" +@session_id,@booking, :expires_in => 30.minutes)
    @pay        = CarsPay.new
    @p_meth     = api.get_payment_methods(@booking.dropp_off.location).collect{|m| [m[:name],m[:id]]}
  end

  def rules
    @rental_terms = api.get_rental_terms params[:id]
    render :partial => "shared/cars_rules"
  end

  def book
    json = {:success=>false,:msg=>I18n.t("all.server_error")}
    CarsBooking.new
    card_info = CarsPay.new(params[:cars_pay])
    booking   = Rails.cache.read("auto_last_booking_"+card_info.session_id)
    booking.vehicle_id = params[:id]
    booking.user = current_user
    book_id   = api.make_booking booking , card_info
    if api.error.nil? and !book_id.nil?
      payed_booking = CarsBookingsPayed.new
      payed_booking.set_data(booking,book_id,current_user)
      payed_booking.save
      json = {:success=>true,:id=>payed_booking.id}
    else
      json = {:success=>false,:msg=>api.error[:text]}
    end
  ensure
      render :json => json
  end

  ##################### Car forms actions ####################

  def pick_up_city
    data = api.get_city_list params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false}
    else
    cities = data.kind_of?(String) ? [option.call(t("search.cars.pick_up_city"),""),option.call(data,data)].join("") : [option.call(t("search.cars.pick_up_city"),""),data.collect{|c| option.call(c,c)}].flatten.join("")
    render :json =>{:success=>true,:options=>cities}
    end
  end
   
  def pick_up_location
    data = CarCityLocation.where(car_city_id:params[:id].to_i)
    locations = [option.call(t("search.cars.pick_up_place"),""),data.collect{|c| option.call(c.name,c.location_id.to_s)}].flatten.join("")
    render :json =>{:success=>true,:options=>locations}
    # data = api.get_location_list params[:prev] ,params[:id]
    # if data.kind_of?(Array) and data.size == 0
    #   render :json =>{:success=>false}
    # else
    #   data = sort_paces data
    #   locations = [option.call(t("search.cars.pick_up_place"),""),data.collect{|c| option.call(c.name,c.location_id)}].flatten.join("")
    #   render :json =>{:success=>true,:options=>locations}
    # end
  end
  
  def dropp_off_country
    data = api.get_dropp_off_country_list params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false}
    else
      countries = data.kind_of?(String) ? [option.call(t("search.cars.dropp_off_country"),""),option.call(data,data)].join("") : [option.call(t("search.cars.dropp_off_country"),""),data.collect{|c| option.call(c,c)}].flatten.join("")
      render :json =>{:success=>true,:options=>countries}
    end
  end

  def dropp_off_city
    data = api.get_dropp_off_city_list params[:pick_loc],params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false}
    else
      cities = data.kind_of?(String) ? [option.call(t("search.cars.dropp_off_city"),""),option.call(data,data)].join("") : [option.call(t("search.cars.dropp_off_city"),""),data.collect{|c| option.call(c,c)}].flatten.join("")
      render :json =>{:success=>true,:options=>cities}
    end
  end
  
  def dropp_off_location
    data = api.get_dropp_off_locations_list params[:pick_loc],params[:prev] ,params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false}
    else
      data = sort_paces data
      locations = locations = [option.call(t("search.cars.dropp_off_place"),""),data.collect{|c| option.call(c[:name],c[:id])}].flatten.join("")
      render :json =>{:success=>true,:options=>locations}
    end
  end
  
  def pick_up_open_time
    data = api.get_open_time_list params[:pick_loc],params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false,:text=>t("search.cars.dont_work")}
    else
      
      data = data.collect{|c| option.call(c,c)}.join("")
      render :json => {:success=>true,:options=>data}
    end
  end
  
  def dropp_off_open_time
    data = api.get_dropp_off_open_time_list params[:pick_loc],params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false,:text=>t("search.cars.dont_work")}
    else
      data = data.collect{|c| option.call(c,c)}.join("")
      render :json => {:success=>true,:options=>data}
    end
  end
  #####################################################################3
  
  
  def payment_error

    unless logged_in?
      redirect_to :root
    else
      @error = Rails.cache.read("error_#{params[:id]}")
      render :template => 'auto/pay_error'     
    end   
  end
  
  
  private

  def option
    @option ||= Proc.new{|string,id| "<option value=\"#{id.force_encoding("UTF-8")}\">#{string.force_encoding("UTF-8")}</option>"}
  end
  def check_protect
    protect_el = false
    @booking.extras.each do |e|
      if e.name == I18n.t('all.cars.franchize')
        protect_el = e
      end
    end
      if protect_el
        @booking.car_price  = @booking.base_price.to_f + protect_el.price.to_f * @search.interval_check
        @booking.protect       = 1
        @booking.protect_price = protect_el.price.to_f
      elsif @booking.protect == 1
        @booking.car_price -= @booking.protect_price * @search.interval_check
      else
        @booking.car_price = @booking.base_price
      end  
    end
  def get_car_item
    @car = nil
    @results = @results.nil? ? [] : @results
    @results.each do |car|
      @car = car if car[:car_info][:id] == params[:id]
    end
  end
  
  def check_cache
    CarsSearch.new(:pick_up => CarsLocation.new , :dropp_off=>CarsLocation.new , :driver_age=>nil)
    @session_id = params[:session_id]
    @search     = Rails.cache.read("auto_search_query_" +@session_id)
    @results    = Rails.cache.read("auto_search_result_"+@session_id)
    redirect_to :root if @results.nil? || @search.nil?
  end
  
  def sort_paces places
    sort = I18n.t('search.cars.airport')
    out  = []
    places.each do |i|
      out.push(i) unless CGI::unescape(i[:name]).match(/#{sort}/).nil?
    end
    places.each do |i|
      out.push(i) unless out.include?(i)
    end
    out
  end
  
  def api
    @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
  end
    
  
end