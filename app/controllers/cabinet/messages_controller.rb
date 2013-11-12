class Cabinet::MessagesController < UserController
	before_filter :require_login

	def index
	end
	
	def show
		@title = "#{current_user.first_name} #{current_user.last_name}"
	end


	
end