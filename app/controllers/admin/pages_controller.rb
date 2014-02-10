class Admin::PagesController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@pages = Page.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
	end
	def edit
		@page = Page.find(params[:id])
	end
	def new
		@page = Page.new
	end
	def create
		Page.create(params[:page])
		redirect_to admin_pages_path
	end

	def update
		page = Page.find(params[:id])
		page.update_attributes(params[:page])
		flash[:notice] = t("admin.emails.changed")
		redirect_to admin_pages_path
	end

end