class Cabinet::HousesController < UserController
	before_filter :require_login

	def initialize
		super
		@currency = $currency.present? ? Currency.find_by_title($currency.to_s) : Currency.find_by_title('USD')
	end
	
	def index
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

	def houses_filter
		# @bookings = ApartmentsBooking.where("created_at > #{Date.strptime(params[:from],"%d.%m.%Y").to_time} AND created_at < #{Date.strptime(params[:to],"%d.%m.%Y").to_time}")
		conditions = {:created_at => Date.strptime(params[:from],"%d.%m.%Y").beginning_of_day..Date.strptime(params[:to],"%d.%m.%Y").end_of_day, :status => [params[:status].split(',')]}
		@bookings = ApartmentsBooking.find(:all, :conditions => conditions, :order => 'created_at DESC')
		html = render_to_string partial: 'items'
		render :json => { :html => html, :status => true}
	end

	def show
		
	end

	
end