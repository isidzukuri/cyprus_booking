class HomeController < ApplicationController
	include ActionView::Helpers::TagHelper
	def index
	end

	def apartments
		facilities = Facility.where(:active=>1).map do |item|
			ApartmentFacifility.new({:name=>item.name_ru,:id=>item.id})
		end
		@apartments_search = ApartmentSearch.new(:facilities => facilities)
		render :layout =>"map"
	end

end
