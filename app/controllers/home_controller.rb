class HomeController < ApplicationController
	include ActionView::Helpers::TagHelper
	def index

		@penalty = Penalty.new
		@regions = Region.order("name_#{I18n.locale} ASC").all.map{|r| [r.name,r.id]}
		id = params[:region_id].to_i == 0 ? @regions.first.last : params[:region_id].to_i rescue 0
		details = PaymentDetail.order("name_#{I18n.locale} ASC").where(:region_id=>id).map{|det| content_tag(:option,det.name,:value=>det.id)}.join
		respond_to do |format|
			format.js {render :json=>{:regions=> details } }
			format.html
		end
	end


	def details
		@penalty  = Penalty.new(params[:penalty])
		@user 	  = logged_in? ? current_user : User.new
		@password = SecureRandom.hex(10)
	end


	def check_details
		@offerta = AdminSettings.find_by_setting(:"oferta_#{I18n.locale}").value
		@url = create_penalty_path
		redirect_to :root if params[:penalty].nil?
		if logged_in?
			params[:penalty].delete(:user_attributes)
			@penalty = Penalty.new(params[:penalty])
			@penalty.user = current_user
			@pm = manager
		else
			role = Role.find_by_role_type(:login)
			@penalty = Penalty.new(params[:penalty])
			user = @penalty.user
			user.roles << role
			if user.valid?
				user.save
				auto_login(user)
				AppMailer.registration(params[:penalty][:user_attributes][:password],user,request.domain).deliver
				@penalty = Penalty.new(params[:penalty])
				@penalty.user = current_user
				@pm = manager
			else
				flash.now[:errors] = user.errors.messages
 				render :template => "home/details"
 			end
		end
	end


	def create_penalty
		@penalty        = Penalty.new(params[:penalty])
		@penalty.user   = current_user
		@penalty.status = 1
		@penalty.set_total
		@penalty.save
		if @penalty.valid?
			manager.create_paymnet(@penalty) 
			json = {:success=>true,:form=>payment_form}
		else
			json = {:success=>false,:error=>t("front_all.duplicat_error")}
		end
		render :json => json
	end

	def payment_success
		redirect_to root_path unless penalty = Penalty.find(params[:order_id].to_i)
		custom  = param[:custom_field]
		result  = manager.process_payment penalty # , custom.first , custom.last 
	end

	def pay
		Penalty.new
		json = {}
		unless penalty = Rails.cache.read("#{current_user.id}_last_penalty")
			json = {:success=>true, :error=>t("front_all.timeout_error")} 
		else
			payment = Payment.new(params[:payment])
			
		end
		render :json => json
	end


	private

	def payment_form
		@api_key = AdminSettings.find_by_setting(:shop_api_key).value 
		@desc    = t("front_all.pay_desc" , :number =>  @penalty.number) 
		@sign    = Digest::MD5.hexdigest([@api_key, [@desc ,  @penalty.id,  @penalty.total_cost, "UAH"].join , AdminSettings.find_by_setting(:shop_secret_key).value ].join)
		return render_to_string(:partial=>"shared/payment_form")
	end

	def manager
		@manager ||= PaymentManager.new
	end
		
end
