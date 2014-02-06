class Admin::NearbiesController < AdminController
	before_filter :require_login
	def index
		per_page = 20
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		unless params[:name_ru].nil?
			@facilities = Nearby.where("name_ru LIKE ?","#{params[:name_ru]}%").paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		else
			@facilities = Nearby.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		end
	end

	def new
		@facility  = Nearby.new
	end

	def create
		facility = Nearby.new(params[:nearby])
		p facility
		if facility.valid?
			facility.save
			flash[:notice] = t("facility.actions.added")
		else
			flash[:errors] = facility.errors.messages
		end
		redirect_to admin_nearbies_path
	end

	def edit
		@facility = Nearby.find(params[:id])
	end

	def update
		facility = Nearby.find(params[:id])
		facility.update_attributes(params[:nearby])
		if facility.valid?
			if params[:ico].present? 
				facility.ico = params[:ico]
			end
			facility.save
			flash[:notice] = t("facility.actions.changed")
		else
			flash[:errors] = facility.errors.messages
		end
		redirect_to admin_nearbies_path
	end

	def delete
		facility = Nearby.find(params[:id])
		facility.delete
		flash[:notice] = t("facility.actions.deleted")
		redirect_to admin_nearbies_path
	end

	

end