class CabinetController < ApplicationController
	before_filter :require_login

	def initialize
		super
		@currency = Currency.find_by_title($currency.to_s)
	end
	
	def houses
		@title = "Dashboard"
		@bookings = current_user.apartments_bookings

		# per_page = 20
		# sort = params[:sort] || :id
		# @dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		# unless params[:name_ru].nil?
		# 	@apartaments = House.where("name_ru LIKE ?","#{params[:name_ru]}%").paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		# else
		# 	@apartaments = House.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		# end
	end

	

	
end