class HomeController < ApplicationController
	def index 
	end

	def change_currency
		cookies.permanent[:currency] = params[:currency].strip
		render :json => {:status=>true}
	end

	def login
		redirect_to :root if logged_in?
	end
end
