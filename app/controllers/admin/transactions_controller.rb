class Admin::TransactionsController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@transactions = Transaction.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
	end

	def show
		@penalty = Transaction.find(params[:id])
	end

end