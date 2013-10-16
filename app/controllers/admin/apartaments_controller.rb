class Admin::ApartamentsController < AdminController
	before_filter :require_login
	def index
		per_page = 20
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		unless params[:name_ru].nil?
			@apartaments = House.where("name_ru LIKE ?","#{params[:name_ru]}%").paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		else
			@apartaments = House.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		end
	end

	def new
		@apartament = House.new
		@apartament.user_id = @apartament.user_id.present? ? @apartament.user_id : @current_user.id 
		@cities = City.all.map{|city| [city.name_ru,city.id]}
		@currencies = Currency.all.map{|c| [c.title,c.id]}
		@facilities = Facility.where("active = 1").map{|f| [f.name_ru,f.id]}
		@currency = Currency.find(1)
	end

	def create
		@photos = params[:house][:photos]
		params[:house].delete(:photos)
		facilities_ids = []
		facilities_ids = params[:house][:facilities].keys unless !params[:house][:facilities].present?
		params[:house].delete(:facilities)
		@apartament = House.new(params[:house])
		@apartament.facilities = Facility.find(facilities_ids)
		# if @apartament.valid?
			@apartament.save
			save_dependencies()
			flash[:notice] = t("apartament.actions.added")
		# else
		# 	flash[:errors] = apartament.errors.messages
		# end
		redirect_to admin_apartaments_path
	end

	def edit
		@apartament = House.find(params[:id])
		@cities = City.all.map{|city| [city.name_ru,city.id]}
		@currencies = Currency.all.map{|c| [c.title,c.id]}
		@facilities = Facility.where("active = 1").map{|f| [f.name_ru,f.id]}
		employments = @apartament.employments.where(:status => [1,2,3]).where("to_date > ?", Time.now.to_i)
		@reserved = {'owner' => [],'client' => []}

		if employments.present?
			disabled_days = []
			employments.each do |r|
				curent_day = r.from_date
				begin
					disabled_days << "'#{Time.at(curent_day).strftime("#{Time.at(curent_day).day}.#{Time.at(curent_day).month}.%Y")}'"
					curent_day += 86400
				end while curent_day <= r.to_date
				if r.status == 1
					@reserved['owner'] << r
				else
					@reserved['client'] << r
				end	
			end
			@disabled_days = disabled_days.join(', ') if disabled_days.any?
		end
		@custom_prices = {}
		@prices = @apartament.house_prices.where("to_date > ?", Time.now.to_i)
		if @prices.present?
			price_calendar_disabled_days = []
			@price_calendar_values = []
			@prices.each do |r|
				curent_day = r.from_date
				begin
					day = "#{Time.at(curent_day).strftime("#{Time.at(curent_day).day}.#{Time.at(curent_day).month}.%Y")}"
					price_calendar_disabled_days << "'#{day}'"
					@price_calendar_values << r.cost
					curent_day += 86400
				end while curent_day <= r.to_date
			end
		end
		@price_calendar_disabled_days = price_calendar_disabled_days.join(', ') if !price_calendar_disabled_days.nil? && price_calendar_disabled_days.any?
		@price_calendar_values = @price_calendar_values.to_json
		@currency = Currency.find(@apartament.currency_id)
	end

	def update
		@photos = params[:house][:photos]
		params[:house].delete(:photos)
		facilities_ids = []
		facilities_ids = params[:house][:facilities].keys unless !params[:house][:facilities].present?
		params[:house].delete(:facilities)
		@apartament = House.find(params[:id])
		@apartament.update_attributes(params[:house])
		@apartament.facilities = Facility.find(facilities_ids)
		# if @apartament.valid?
			save_dependencies()
			flash[:notice] = t("apartament.actions.changed")
		# else
		# 	flash[:errors] = apartament.errors.messages
		# end
		redirect_to admin_apartaments_path
	end

	def delete
		apartament = House.find(params[:id])
		apartament.photos.each do |photo|
			photo.file.destroy
		end
		apartament.delete
		flash[:notice] = t("apartament.actions.deleted")
		redirect_to admin_apartaments_path
	end

	def remove_photo
		@photo = Photo.find(params[:photo_id])
		@photo.file.destroy
		@photo.delete
		render :text => @photo.delete
	end

	def remove_employment
		@period = Employment.find(params[:id])
		render :text => @period.delete
	end

	def remove_price
		@period = HousePrice.find(params[:id])
		render :text => @period.delete
	end

	def save_dependencies
		@apartament.save
		if @photos.present? 
			@photos.each do |one|
				@photo = Photo.new()
				@photo.file = one
				@photo.house_id = @apartament.id
				@photo.save
			end
		end
		if params[:employment_from].present? 
			params[:employment_from].each_with_index do |one,i|
				@period = Employment.new()
				@period.from_date = Time.strptime(one,"%d.%m.%Y").to_i
				@period.to_date = Time.strptime(params[:employment_to][i],"%d.%m.%Y").to_i
				@period.status = 1
				@period.house_id = @apartament.id
				@period.save
			end
		end
		if params[:price_from].present? 
			params[:price_from].each_with_index do |one,i|
				@period = HousePrice.new()
				@period.from_date = Time.strptime(one,"%d.%m.%Y").to_i
				@period.to_date = Time.strptime(params[:price_to][i],"%d.%m.%Y").to_i
				@period.cost = params[:price_range_value][i]
				@period.house_id = @apartament.id
				@period.save
			end
		end
	end

	
end