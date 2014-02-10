class Cabinet::AutoController < ApplicationController

	def index
			
	end	
	def show
		@book = current_user.cars_bookings_payeds.where(id:params[:id].to_i).first
		raise "Booking not found" if @book.nil?
		@rental_terms = api.get_rental_terms @book.pick_location
	end
	def edit
		
	end

	private

    def api
      @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
    end


    def set_layout
      @body_cls = "faq_page cabinet"
      @active_tab  = 1
      @active_link = 2
    end
end