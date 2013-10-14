class Admin::CurrenciesController < AdminController
	before_filter :require_login
	def index
		per_page = 20
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		unless params[:title].nil?
			@facilities = Currency.where("title LIKE ?","#{params[:name_ru]}%").paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		else
			@facilities = Currency.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		end
	end

	def new
		@facility  = Currency.new
	end

	def create
		facility = Currency.new(params[:currency])
		p facility
		if facility.valid?
			facility.save
			flash[:notice] = t("facility.actions.added")
		else
			flash[:errors] = facility.errors.messages
		end
		redirect_to admin_currencies_path
	end

	def edit
		@facility = Currency.find(params[:id])
	end

	def update
		facility = Currency.find(params[:id])
		facility.update_attributes(params[:currency])
		if facility.valid?
			if params[:ico].present? 
				facility.ico = params[:ico]
			end
			facility.save
			flash[:notice] = t("facility.actions.changed")
		else
			flash[:errors] = facility.errors.messages
		end
		redirect_to admin_currencies_path
	end

	def delete
		facility = Currency.find(params[:id])
		facility.delete
		flash[:notice] = t("facility.actions.deleted")
		redirect_to admin_currencies_path
	end

	

end