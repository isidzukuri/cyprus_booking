class Cabinet::ProfileController < UserController
	before_filter :require_login


	
	def show
		@title = t("front_all.user_profile")
	end


	
end