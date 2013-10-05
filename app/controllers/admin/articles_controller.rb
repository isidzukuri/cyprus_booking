class Admin::ArticlesController < AdminController
	before_filter :require_login
	@@per_page = 10
	def index
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@details = PaymentDetail.paginate(:per_page=>@@per_page,:page => params[:page]).order("#{sort} #{@dir}")
	end

	def banks
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@banks = Bank.paginate(:per_page=>@@per_page,:page => params[:page]).order("#{sort} #{@dir}")
	end

	def regions
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@regions = Region.paginate(:per_page=>@@per_page,:page => params[:page]).order("#{sort} #{@dir}")
	end

	def new
		@detail  = PaymentDetail.new
		set_data
	end

	def edit
		@detail  = PaymentDetail.find(params[:id])
		set_data		
	end

	def save_detail
		detail  = params[:id].to_i == 0 ? PaymentDetail.new(params[:payment_detail]) : PaymentDetail.find(params[:id])
		if detail.valid?
			params[:id].to_i == 0 ? detail.save : detail.update_attributes(params[:payment_detail])
			flash[:notice] = t("admin.articles.saved")
		else
			flash[:errors] = detail.errors.messages
		end
		redirect_to "/admin/articles"
	end

	def get_form
		type = params[:edit].constantize
		@item = params[:id].to_i == 0 ? type.new : type.find(params[:id])
		html  = render_to_string(:partial=>"admin/articles/#{params[:edit].downcase}_form")
		render  :json => {:success=>true,:html=>html}
	end

	def delete_dic
		type = params[:delete].constantize
		item = type.find(params[:id])
		if item.payment_details.count > 0
			flash[:error] = t("admin.articles.default_error")
		else
			item.delete
			flash[:notice] = t("admin.articles.delete_success")
		end
		render :json => {:success=>true}
	end

	def save_item
		_type = params[:save_type].downcase
		type  = params[:save_type].constantize
		item  = params[:id].to_i == 0 ? type.new(params[:"#{_type}"]) : type.find(params[:id])
		if params[:id].to_i == 0
			if item.valid?
				item.save
				flash[:notice] = t("admin.articles.saved")
			else
				flash[:errors] = item.errors.messages
			end
		else
			item.update_attributes(params[:"#{_type}"])
			if item.valid?
				flash[:notice] = t("admin.articles.saved")
			else
				flash[:errors] = item.errors.messages
			end
		end
		redirect_to "/admin/articles/#{_type.pluralize}"
	end

	private 
	def set_data
		@banks   = Bank.all.map{|bank| [bank.name,bank.id]} 
		@regions = Region.all.map{|bank| [bank.name,bank.id]} 
		@budget_code_names = t("admin.articles.kkdb_types").each_pair.map{|k,v| [v,k]}
		@budget_codes = [[21081300,21081300],[21081100,21081100]]
	end

end