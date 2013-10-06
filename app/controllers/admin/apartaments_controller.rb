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
		@facilities = Facility.where("active = 1").map{|f| [f.name_ru,f.id]}
	end

	def create
		photos = params[:house][:photos]
		params[:house].delete(:photos)
		facilities_ids = []
		facilities_ids = params[:house][:facilities].keys unless !params[:house][:facilities].present?
		params[:house].delete(:facilities)
		apartament = House.new(params[:house])
		apartament.facilities = Facility.find(facilities_ids)
		# if apartament.valid?
			apartament.save
			if photos.present? 
				photos.each do |one|
					@photo = Photo.new()
					@photo.file = one
					@photo.house_id = apartament.id
					@photo.save
				end
			end
			flash[:notice] = t("apartament.actions.added")
		# else
		# 	flash[:errors] = apartament.errors.messages
		# end
		redirect_to admin_apartaments_path
	end

	def edit
		@apartament = House.find(params[:id])
		@cities = City.all.map{|city| [city.name_ru,city.id]}
		@facilities = Facility.where("active = 1").map{|f| [f.name_ru,f.id]}
	end

	def update
		photos = params[:house][:photos]
		params[:house].delete(:photos)
		facilities_ids = []
		facilities_ids = params[:house][:facilities].keys unless !params[:house][:facilities].present?
		params[:house].delete(:facilities)
		apartament = House.find(params[:id])
		apartament.update_attributes(params[:house])
		apartament.facilities = Facility.find(facilities_ids)
		# if apartament.valid?
			apartament.save
			if photos.present? 
				photos.each do |one|
					@photo = Photo.new()
					@photo.file = one
					@photo.house_id = apartament.id
					@photo.save
				end
			end
			flash[:notice] = t("apartament.actions.changed")
		# else
		# 	flash[:errors] = apartament.errors.messages
		# end
		redirect_to admin_apartaments_path
	end

	def delete
		apartament = House.find(params[:id])
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

	
end