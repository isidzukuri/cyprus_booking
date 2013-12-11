class ApartmentsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	include ActionView::Helpers::TagHelper

	def initialize
		super
		@currency = Currency.find_by_title($currency.to_s)
		@cls = "hotel_page"
	end

	def index
	  facilities = Facility.where(:active=>1).map do |item|
	    ApartmentFacifility.new({:name=>item.name_ru,:id=>item.id,:ico=>item.ico})
	  end
	  @apartments_search = ApartmentSearch.new(:facilities => facilities)
	  render :layout =>"map"
	end

	def complete
		cities = City.search params[:term]
		render :json => cities.to_json
	end

	def get_prices
	    house = House.find(params[:id])
	    json = house.nil? ? {:prices=>[],:employtments=>[]} : {:prices=>house.changed_prices,:employtments =>house.busy_dates}
	    render :json => json
	end

	def refresh_price
		json = {:changed=>false,:busy=>:false}
		if house = House.find(params[:id])
			ApartmentSearch.new
			@search = Marshal.load(cookies[:last_apartment_search])

	        if !house.is_busy?(@search)
				@search.arrival   = params[:arrival]
				@search.departure = params[:departure]
		        cookies[:last_apartment_search] = {
		          :value   => Marshal.dump(@search),
		          :expires => 24.hours.from_now
		        }
	        	json = {:changed=>true,:price=>house.period_price(@search)}
	        else
	        	json = {:changed=>false,:busy=>true}
	        end
		end
		sleep 2
		render :json => json
	end

	def search
	  begin
		  @search = ApartmentSearch.new(params[:apartment_search])
		  ids    = @search.facilities.map{|e| e.active == 0 ? nil : e.id }.compact
		  facilities = ids.any? ? Facility.where("id IN (#{ids.join(",")})") : []
	      cookies[:last_apartment_search] = {
	        :value   => Marshal.dump(@search),
	        :expires => 24.hours.from_now
	      }
	      conditions = "places >= #{@search.people_count}  AND city_id = #{@search.city_id}" 
	      apartments = House.where(conditions)
	      apartments_ = []
	        apartments.each do |ap|
	      	if facilities.any?
		      	facilities.each do |f|
		      		if ap.facilities.include?(f)
		      			if @search.price_from.to_i!=0 && @search.price_to.to_i!=1000
		      				price = ap.period_price(@search)
		      				apartments_ << ap if price <= @search.price_to.to_i && price >= @search.price_from.to_i
		      			else
		      				apartments_ << ap
		      			end
		      			
		      		end      		
		      	end
		    else
				if @search.price_from.to_i!=0 && @search.price_to.to_i!=1000
					price = ap.period_price(@search)
					apartments_ << ap if price <= @search.price_to.to_i && price >= @search.price_from.to_i
				else
					apartments_ << ap
				end
	      	end
	      end

	      apartments = apartments.joins(:facilities) if ids.any?
	      @apartments = apartments_.map{|a| a.is_busy?(@search) ? nil : a.to_search(@search)}.compact
	      json = {:success=>true,:data=>apartments, :html => render_to_string(:partial => "apartments/list")} 
      rescue
      	  json = {:success=>false} 
      ensure
        render :json  => json
      end
	end 

	def show_index
		ApartmentSearch.new
		@search = Marshal.load(cookies[:last_apartment_search])
		@apartment = House.find(params[:id])
		render :json  => {:html=>render_to_string( "apartments/_min_view", :layout => false)}
	end

	def to_wish
	  ap = House.find(request.referer.split("/").last.to_i)
	  json = {:succes=>false}
	  unless current_user.apart_in_wish? ap
	  	Wish.create(:house_id=>ap.id,:user_id=>current_user.id)
	  	json = {:success=>true}
	  end
	  render :json => json
	end
	def remove_from_wish
	  ap = House.find(request.referer.split("/").last.to_i)
	  json = {:succes=>false}
	  if current_user.apart_in_wish? ap
	  	current_user.wishes.where(:house_id=>1).first.delete
	  	json = {:success=>true}
	  end
	  render :json => json
	end

	def show 
	  @apartment = House.find(params[:id])
	  ApartmentSearch.new
	  @search = Marshal.load(cookies[:last_apartment_search])
	end

	def booking
	  @apartment = House.find(params[:id])
	  ApartmentSearch.new
	  @search = Marshal.load(cookies[:last_apartment_search])
	  @booking = ApartmentsBooking.new(
	  	:travelers  => [Traveler.new()],
	  	:house_id   => @apartment.id,
	  	:seller 	=> @apartment.user_id,
	  	:from_date  => @search.arrival.to_time.to_i,
	  	:to_date    => @search.departure.to_time.to_i,
	  	:total_cost => @apartment.period_price(@search),
	  	:currency   => $currency
	  	)
	end

	def pay
	  return unless logged_in?

	  ApartmentSearch.new
	  search = Marshal.load(cookies[:last_apartment_search])
	  booking = ApartmentsBooking.new(params[:apartments_booking])
	  return if booking.house.is_busy?
	  booking.user_id = current_user.id
	  booking.save
	  booking.travelers <<  params[:travelers].map{|tr| tr = Traveler.new(tr);tr.apartments_booking_id = booking.id; tr}
	  booking.save
	  redirect_to cabinet_houses_path
	end


end

