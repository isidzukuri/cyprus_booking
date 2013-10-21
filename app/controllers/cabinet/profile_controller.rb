class Cabinet::ProfileController < UserController
	before_filter :require_login


	
	def show
		@title = "#{current_user.first_name} #{current_user.last_name}"
	end


	
end