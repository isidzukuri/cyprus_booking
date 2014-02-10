class Cabinet::HotelsController < ApplicationController

	def index
			
	end	
	def show
		@book = current_user.hotel_booking_payeds.where(id:params[:id].to_i).first
		raise "Booking not found" if @book.nil?
	end
	def edit
		
	end

	private
    def set_layout
      @body_cls = "faq_page cabinet"
      @active_tab  = 1
      @active_link = 1
    end
end