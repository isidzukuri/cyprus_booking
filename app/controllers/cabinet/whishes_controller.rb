class Cabinet::WhishesController < UserController
	before_filter :require_login

	def index
		@title = t("cabinet.whishes")
		@whishes = current_user.wishes
	end
	
	def show
		@title = "#{current_user.first_name} #{current_user.last_name}"
	end


	
end