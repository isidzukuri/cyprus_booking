class CarsController < ApplicationController

  before_filter :check_cache, :only=>[:results,:show]

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
    @id = params[:id].to_i  
  end

  private

  def check_cache
    CarsSearch.new(:pick_up => CarsLocation.new , :dropp_off=>CarsLocation.new , :driver_age=>nil)
    @session_id = params[:session_id]
    @search     = Rails.cache.read("auto_search_query_" +@session_id)
    @results    = Rails.cache.read("auto_search_result_"+@session_id)
    redirect_to :root if @results.nil? or @search.nil?
  end





  def book
    
    @session_id  = params[:session_id]
    @booking    = CarsBooking.new params[:cars_booking]
    search     = cookies[:auto_search_locations].blank? ? nil : Marshal.load(cookies[:auto_search_locations])
    pick = api.get_location_info search[:pick_up][:location]
    dropp = api.get_location_info search[:dropp_off][:location]
      
    @booking.dropp_off = CarsLocation.new search[:dropp_off]
    @booking.pick_up   = CarsLocation.new search[:pick_up]

    @booking.dropp_off.country = pick[:country]
    @booking.pick_up.country   = dropp[:country]

    Rails.cache.write("auto_booking_"+@session_id, @booking, :expires_in => 30.minutes)
    render :json => {:payment_form => render_to_string(:partial => 'auto/book', :locals => {:session_id => @session_id})}
  end
  

  

  
  
  def info
    CarsSearch.new
    @session_id = params[:session_id]
    @car = api.get_car_info params[:car_id]
    price = params[:price].gsub("n","").gsub("t","").gsub("\\","").gsub("    ","")
    price = eval(price)
    @car.merge!(:price => price, :location =>params[:location])
    @car[:ImageURL] = params[:image_url]
    Rails.cache.write("auto_"+@session_id, @car, :expires_in => 30.minutes)
    car_locations = {:pick_up => params[:pick_up] ,:dropp_off =>params[:dropp_off]}
    cookies[:auto_search_locations] = {
      :value   => Marshal.dump(car_locations),
      :expires => 24.hours.from_now
    }
    @franc       = false
    @search      = cookies[:last_cars_search].blank? ? nil : Marshal.load(cookies[:last_cars_search])
    @car_extra = api.get_car_extra params[:car_id]
    check_car_protection

    @interval    = (Time.parse(@search.dropp_off.date).to_i - Time.parse(@search.pick_up.date).to_i) / 86400
    count        = @car_extra.count
    user         = logged_in? ? current_user : User.new(:phone_code => "+38")
    @booking     = CarsBooking.new(:extras=>[CarsExtras.new]*count,:driver=>Driver.new , :user=>user ,:pick_up => CarsLocation.new, :dropp_off => CarsLocation.new )
    @phone_codes = v_api.phone_codes.map{ |p| ["+"+p[:country_phone], "+"+p[:country_phone]] }
    
    @pick_up_countries = cars_countries
    @cars_search  = CarsSearch.new(:pick_up => CarsLocation.new , :dropp_off=>CarsLocation.new, :driver_age=>nil)
    @rental_terms = api.get_rental_terms @car[:location]

    data = @rental_terms.size > 0 ? @rental_terms[0][:text][0][:Caption] == I18n.t('auto.plus_optons_pattern') ? @rental_terms[0][:text][0][:Body] : nil : nil
    @text = data.nil? ? [] : data.split('*').map{|i| i.gsub("<br />" , "")}
    html = render_to_string :template =>"auto/car_info" ,:layout =>false
    left_html = render_to_string(:partial => 'auto/mustache/first_order_desc')
    currencies = render_to_string(:partial => 'auto/mustache/currencies_block')
    render :json => {:status=>'success' , :html => html ,:left=>left_html,:curr =>"" } #currencies
  end
  
  def booking_create
    begin
      CarsBooking.new
      CarsSearch.new
      @session_id  = params[:session_id]
      @booking     = Rails.cache.read("auto_booking_"+@session_id)
      @pay         = CarsPay.new
      @car         = Rails.cache.read("auto_"+@session_id)
      @search      = cookies[:last_cars_search].blank? ? nil : Marshal.load(cookies[:last_cars_search])
      @interval    = (Time.parse(@booking.dropp_off.date).to_i - Time.parse(@booking.pick_up.date).to_i) / 86400
      @car_extra   = @booking.extras
      check_car_protection
      @p_meth      = api.get_payment_methods(@booking.dropp_off.location).collect{|m| [m[:name],m[:id]]}
      render :template =>"auto/pay_page" if @add_protect.nil?
    rescue
     redirect_to request.referer
    end
  end
  
  
  def set_car_protect
    @add_protect = true
    booking_create
    @booking.extras.collect do |ex|
      if ex.id == @protect_item.id
        ex.count =  params[:type].to_i
        @booking.protect = params[:type].to_i
      else
        ex.count = ex.count
      end
    end
    Rails.cache.write("auto_booking_"+@session_id,@booking) unless @booking.protect == 1  
    html = render_to_string :partial =>"auto/mustache/order_desc" ,:layout =>false
    render :json => {:html=>html,:success=>true}
    #rescue
     # render :json => {:success=>false}
  end
  



  ##################### Car forms actions ####################
  def option
    @option ||= Proc.new{|string,id| "<option value=\"#{id.force_encoding("UTF-8")}\">#{string.force_encoding("UTF-8")}</option>"}
  end
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
    data = api.get_location_list params[:prev] ,params[:id]
    if data.kind_of?(Array) and data.size == 0
      render :json =>{:success=>false}
    else
      data = sort_paces data
      locations = [option.call(t("search.cars.pick_up_place"),""),data.collect{|c| option.call(c[:name],c[:id])}].flatten.join("")
      render :json =>{:success=>true,:options=>locations}
    end
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
  

  def thanks
    unless logged_in?
      redirect_to :root
    else
      @text = Thanks.find_by_page_type("auto").text
      render :template => 'home/thanks'
    end
  end
  
  def payment_error

    unless logged_in?
      redirect_to :root
    else
      @error = Rails.cache.read("error_#{params[:id]}")
      render :template => 'auto/pay_error'     
    end   
  end
  
  
  private
  
  
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
  
  
  def check_car_protection
    @car_extra.each do |t|
      @franc = t[:name] == I18n.t('auto.franchize') ? true : false
      if @franc
        @protect_item = t
        break
      end
    end  
        
  end
  
  def api
    @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
  end
    
  
  def v_api
    @v_api ||= Api::TicketsUa::Vocabulary.new(Settings.tickets_api.host, Settings.tickets_api.key)
  end
  
end