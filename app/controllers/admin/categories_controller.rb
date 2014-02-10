class Admin::CategoriesController < AdminController
	before_filter :require_login
	def index
		@categories = Category.all
	end
	def edit
		@category = Category.find(params[:id])
	end
	def new
		@category = Category.new
	end
	def create
		Category.create(params[:category])
		redirect_to admin_categories_path
	end

	def update
		email = Category.find(params[:id])
		email.update_attributes(params[:category])
		flash[:notice] = t("admin.emails.changed")
		redirect_to admin_categories_path
	end

end