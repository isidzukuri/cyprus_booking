class UserController < ApplicationController

	before_filter :require_login , :except => [:auth,:forgot]
    
	def auth
		login(params[:user][:email],params[:user][:password],true)
		json = logged_in? ? {:success=>true} : {:succes=>false,:error=>t("user.errors.default_login_error")}
		render :json => json
	end

	def forgot
		user = User.find_by_email(params[:user][:email])
		if user.nil?
			json = {:success=>false,:error=>t("user.not_exist")}
		else
			pass = SecureRandom.hex(10)
			user.change_password! pass
			AppMailer.password_change(pass,user,request.domain).deliver
			json = {:success=>true,:msg=>t("user.wait_for_forgot")}
		end
		render :json =>json
	end

	def exit
		logout
		redirect_to :root
	end


end
