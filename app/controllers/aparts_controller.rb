class ApartsController < ApplicationController

  before_filter :check_cache, :only=>[:results,:show]
  def set_layout
    @body_cls = "car_page hotel_page apart_page"
  end
  def complete
    cities = City.search params[:filter]
    render :json => cities.map{|c| {value:c.name,code:c.id,desc:c.country}}
  end

  def get_map_items
    apartments = House.where(city_id:params[:id].to_i).map(&:to_map_hash)
    render :json  => {:success=>(apartments.count > 0),:data=>apartments}
  end

  def search
    begin
      @search = ApartSearch.new(params[:apart_search])
      cookies[:last_apartment_search] = {
        :value   => Marshal.dump(@search),
        :expires => 24.hours.from_now
      }
      @session_id  = Digest::MD5.hexdigest("#{@search.to_json}#{request.remote_ip}")
      conditions = "places >= #{@search.people_count} AND city_id = #{@search.city_id}" 
      @apartments = House.where(conditions)
      apartments = @apartments.map{|a| a.is_busy?(@search) ? nil : a.to_map_hash}.compact
      Rails.cache.write("aparts_search_result_"+@session_id, @apartments, :expires_in => 1.hour)
      Rails.cache.write("aparts_search_query_" +@session_id,@search, :expires_in => 1.hour)
      unless params[:map_search].to_bool
        json = {success:true,map_search:params[:map_search].to_bool,url:aparts_results_path(session_id:@session_id)}
      else
        json = {success:true,map_search:params[:map_search].to_bool,data:apartments,html:render_to_string(:partial => "aparts/map_results")}
      end  
    rescue
      json = {success:false} 
    ensure
      render :json  => json
    end
  end

  def results
    check_cache
  end

  def show
    check_cache
    @apart   = House.find(params[:id])
    @booking = ApartmentsBooking.new
  end
  
  def booking
    check_cache
    @apart   = House.find(params[:id])
    @booking = ApartmentsBooking.new(:travelers=>[Traveler.new]*@search.people_count)
  end
  
  def book
    check_cache
    @apart   = House.find(params[:id])
    travelers_ = []
    travelers = params[:apartments_booking].delete(:travelers).each_pair do |i,trav|
          travelers_ << Traveler.new(trav)
    end

    @booking = ApartmentsBooking.new(params[:apartments_booking])
    @booking.house_id = @apart.id
    @booking.currency = $currency
    @booking.travelers  = travelers_
    @booking.total_cost = @apart.period_price(@search)
    @booking.from_date  = @search.arrival.to_time.to_i
    @booking.to_date    = @search.departure.to_time.to_i
    @booking.seller     = @apart.user.id
    @booking.user       = current_user
    @booking.save
    Employment.create(:status=>2,:house_id=>@apart.id,:from_date=>@search.arrival.to_time.to_i,:to_date=>@search.departure.to_time.to_i)
    redirect_to cabinet_aparts_path
  end

  private
  def check_cache
    ApartSearch.new;House.new;Employment.new
    @session_id = params[:session_id]
    @results    = Rails.cache.read("aparts_search_result_"+@session_id)
    @search     = Rails.cache.read("aparts_search_query_" +@session_id)
    redirect_to :root if @results.nil? or @search.nil?
  end
end
