class HomeController < ApplicationController
	include ActionView::Helpers::TagHelper
	def index
	end

	def apartments
		render :layout =>"map"
	end

end
