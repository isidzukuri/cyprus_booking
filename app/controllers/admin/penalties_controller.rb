class Admin::PenaltiesController < AdminController
	before_filter :require_login
	def index
		@penalties = Penalty.paginate(:per_page=>20,:page => params[:page]).order("created_at DESC")
	end
	def show
		@penalty = Penalty.find(params[:id])
	end

end