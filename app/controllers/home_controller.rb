class HomeController < ApplicationController
	def index 
	  facilities = Facility.where(:active=>1).map do |item|
	    ApartmentFacifility.new({:name=>item.name_ru,:id=>item.id,:ico=>item.ico})
	  end
	  @apartments_search = ApartmentSearch.new(:facilities => facilities)
	end

	def change_currency
		cookies.permanent[:currency] = params[:currency].strip
		render :json => {:status=>true}
	end

	def login
		redirect_to :root if logged_in?
	end

	def routing
		 render :status => 404
	end
end
