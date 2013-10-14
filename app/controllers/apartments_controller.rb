class ApartmentsController < ApplicationController

	include ActionView::Helpers::TagHelper

	def index
	  facilities = Facility.where(:active=>1).map do |item|
	    ApartmentFacifility.new({:name=>item.name_ru,:id=>item.id,:ico=>item.ico})
	  end
	  @apartments_search = ApartmentSearch.new(:facilities => facilities)
	  @facilities = House.last.facilities
	  render :layout =>"map"
	end

	def complete
		cities = City.search params[:term]
		render :json => cities.to_json
	end

	def search
	  search = ApartmentSearch.new(params[:apartment_search])
	  ids    = search.facilities.map{|e| e.active == 0 ? nil : e.id }.compact

      cookies[:last_apartment_search] = {
        :value   => Marshal.dump(search),
        :expires => 24.hours.from_now
      }
      conditions = "places >= #{search.people_count}  AND city_id = #{search.city_id}" 
      conditions << " AND 'facilities'.'id' IN (#{ids.join(",")})" if ids.any?
      conditions << " AND cost BETWEEN #{search.price_from} AND #{search.price_to}" if search.price_from.to_i!=50 && search.price_to.to_i!=1000
      apartments = House.where(conditions)
      apartments = apartments.joins(:facilities) if ids.any?
      render :json  => apartments.all.to_json
	end 

end

