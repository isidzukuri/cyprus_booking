class Cabinet::HotelsController < UserController
	before_filter :require_login

	def initialize
		super
		@currency = $currency.present? ? Currency.find_by_title($currency.to_s) : Currency.find_by_title('USD')
		@service = 'hotels'
	end
	
	def index
		@title = t("cabinet.hotel_books")
		@bookings = current_user.hotel_booking_payeds.reverse
	end

	def show
		@booking = current_user.hotel_booking_payeds.find(params[:id])
		@title = t("cabinet.booking",:number=>@booking.reservation_id)
	end

    def booking_cancel
        @booking     = HotelBookingPayed.find(params[:id])
        unless @booking.nil? or @booking.user_id != current_user.id
        json =   @booking.non_refunable ? {:success => false} : {:success => true}
        room = @booking.hotel_doc[params[:room].to_i]
        conf = room.conf_number
          data = {
            :itineraryId => @booking.reservation_id,
            :email => current_user.email,
            :reason => params[:reason],
            :confirmationNumber => conf
  
          }
          api.cancel_book data
          if api.error.nil?
  
            room.canceled = true
            room.save
            d = []
            @booking.hotel_doc.each{|r| d << 1 unless r.canceled}
            if d.size == 0
              @booking.canceled = true 
              @booking.status   = "CD" 
            end
            
            @booking.save
            send_sms
          else
            text = api.error[:text] rescue text = I18n.t('hotels.session_error')
            json = {:success => false, :msg =>text}
          end
        else
          json = {:success => true} 
        end
        ensure 
          render :json => json
    end
    def api
      @api ||= Api::Hotel.new(Settings.hotels_api.host,Settings.hotels_api.cid,Settings.hotels_api.ip,Settings.hotels_api.key,Settings.hotels_api.search_url)
    end
end