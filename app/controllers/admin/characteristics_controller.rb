class Admin::CharacteristicsController < AdminController
	before_filter :require_login
	def index
		per_page = 20
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		unless params[:name_ru].nil?
			@characteristics = Characteristic.where("name_ru LIKE ?","#{params[:name_ru]}%").paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		else
			@characteristics = Characteristic.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
		end
	end

	def new
		@characteristic  = Characteristic.new
	end

	def create
		characteristic = Characteristic.new(params[:characteristic])
		p characteristic
		if characteristic.valid?
			characteristic.save
			flash[:notice] = t("characteristic.actions.added")
		else
			flash[:errors] = characteristic.errors.messages
		end
		redirect_to admin_characteristics_path
	end

	def edit
		@characteristic = Characteristic.find(params[:id])
	end

	def update
		characteristic = Characteristic.find(params[:id])
		characteristic.update_attributes(params[:characteristic])
		# if characteristic.valid?
			characteristic.save
			flash[:notice] = t("characteristic.actions.changed")
		# else
		# 	flash[:errors] = characteristic.errors.messages
		# end
		redirect_to admin_characteristics_path
	end

	def delete
		characteristic = Characteristic.find(params[:id])
		characteristic.delete
		flash[:notice] = t("characteristic.actions.deleted")
		redirect_to admin_characteristics_path
	end

	

end