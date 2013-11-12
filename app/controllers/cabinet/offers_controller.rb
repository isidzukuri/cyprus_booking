class Cabinet::OffersController < UserController
	before_filter :require_login

	def initialize
		super
		@currency = $currency.present? ? Currency.find_by_title($currency.to_s) : Currency.find_by_title('USD')
		@service = 'houses'
		@steps = ['address','facilities','price','details','photos']
	end
	
	def index
		@title = t("cabinet.offers")
		@offers = current_user.houses
	end

	def houses_filter
		# @bookings = ApartmentsBooking.where("created_at > #{Date.strptime(params[:from],"%d.%m.%Y").to_time} AND created_at < #{Date.strptime(params[:to],"%d.%m.%Y").to_time}")
		conditions = {:created_at => Date.strptime(params[:from],"%d.%m.%Y").beginning_of_day..Date.strptime(params[:to],"%d.%m.%Y").end_of_day, :status => [params[:status].split(',')]}
		@bookings = current_user.apartments_bookings.find(:all, :conditions => conditions, :order => 'created_at DESC')
		html = render_to_string partial: 'items'
		render :json => { :html => html, :status => true}
	end

	def show
		
	end

	def new
		@link_base = ""
		@step = "address"
		@title = t("cabinet.new_add")
		@apartament = House.new
		@apartament.user_id = @apartament.user_id.present? ? @apartament.user_id : @current_user.id 
		@cities 	= City.all.map{|city| [city.name_ru,city.id]}
		@facilities = Facility.where("active = 1").map{|f| [f.name_ru,f.id,f.ico]} 
		@nearbies 	= Nearby.all.map{|f| [f.name_ru,f.id,f.ico]} 
	end

	def create
		@apartament = House.new(params[:house])
		@apartament.active = 0
		@apartament.currency_id = @currency.id
		if @apartament.valid?
			@apartament.save
			redirect_to "#{edit_cabinet_offer_path(@apartament)}?step=facilities"
		else
			abort
		end
 	end

 	def edit
 		@step = params[:step]
 		@title = t("cabinet.#{@step}")
		@apartament = House.find(params[:id])
		@facilities = Facility.where(:active=>1).map{|f| [f.name,f.id,f.ico]}
		@nearbies   = Nearby.all.map{|f| [f.name,f.id,f.ico]}
		@link_base = cabinet_house_path(@apartament)
	end

	def destroy
		abort
		@apartament = House.find(params[:id])
		@apartament.destroy
		respond_to do |format|
		  format.html { redirect_to cabinet_offers_path }
		  format.xml  { head :ok }
		end
	end

	def update
		next_step_id = @steps.index(params[:step]).to_i

		@apartament = House.find(params[:id])
		if !params[:house].nil?
			if(params[:house][:facilities].present? || params[:house][:nearbies].present?)
				facilities_ids = params[:house][:facilities].keys unless !params[:house][:facilities].present?
				nearbies_ids   = params[:house][:nearbies].present? ? params[:house][:nearbies].keys : [] 
				params[:house].delete(:facilities)
				params[:house].delete(:nearbies)
				@apartament.facilities = Facility.find(facilities_ids) unless facilities_ids.nil?
				@apartament.nearbies   = Nearby.find(nearbies_ids) unless facilities_ids.nil?
			end
		end
		@apartament.update_attributes(params[:house])
		
		if @apartament.valid?
			@apartament.save
			# save_dependencies()
			flash[:notice] = t("apartament.actions.changed")
			if (@steps[next_step_id+1].present?)
				redirect_to "#{edit_cabinet_offer_path(@apartament)}?step=#{@steps[next_step_id+1]}"
			else
				redirect_to cabinet_offers_path
			end
		else
			abort
		end
	end

	def upload_photos		
		@photo = Photo.new()
		@photo.house_id = params[:id]
		@photo.file = params[:one_photo]
		
		render :json => {:saved => @photo.save, :id => @photo.id, :path => @photo.file.url(:cabinet)}.to_json
	end

	def delete_photo
		@photo = Photo.find(params[:id])
		@photo.file.destroy
		@photo.delete
		render :text => @photo.delete
	end

	
end