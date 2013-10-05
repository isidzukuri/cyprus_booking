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

	def penalties
		@penalties = current_user.penalties.paginate(:per_page=>2,:page => params[:page]).order("created_at DESC")
	end

	def show_penalty
		redirect_to :root unless is_owner?
		@pm  = PaymentManager.new
		@url = user_pay_penalty_path 
	end

	def pay_penalty
		@penalty = Penalty.find(params[:penalty][:id])
		render :json => {:success=>true,:form=>payment_form}
	end

	private 
	def is_owner?
		@penalty = Penalty.find_by_id(params[:id].to_i)
		@penalty.nil? ? false : current_user.penalties.include?(@penalty)
	end

	def payment_form
		@api_key = AdminSettings.find_by_setting(:shop_api_key).value 
		@desc    = t("front_all.pay_desc" , :number =>  @penalty.number) 
		@sign    = Digest::MD5.hexdigest([@api_key, [@desc ,  @penalty.id,  @penalty.total_cost, "UAH"].join , AdminSettings.find_by_setting(:shop_secret_key).value ].join)
		return render_to_string(:partial=>"shared/payment_form")
	end

end
