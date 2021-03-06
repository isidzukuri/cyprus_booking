class UserController < ApplicationController

	before_filter :require_login , :except => [:auth,:forgot,:register,:fbregister]
    
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
			AppMailer.password_change(pass,user,"http://#{request.host}").deliver
			json = {:success=>true,:msg=>t("user.wait_for_forgot")}
		end
		render :json =>json
	end

	def exit
		logout
		redirect_to :root
	end

	def register
	  user_attr = params[:user]
      if User.find_by_email(user_attr[:email]).nil?
        if user_attr[:password] != user_attr[:password_confirmation]
        	json = {:success=>false,:error=>t("user.pass_not_confirm")}
        else
          user_attr.delete(:password_confirmation)
          if user = User.create(user_attr)
	          auto_login user
	          Thread.new do
	            AppMailer.registration(user_attr["password"],user,"http://#{request.host}").deliver
	      	  end
	          json = {:success=>true}
          else
          	  json = {:success=>false,:error=>t("user.data_error")}
          end
        end
      else
      	json = {:success=>false,:error=>t("user.exist")}
      end
      render :json => json
	end

	def fbregister
		data = {
			:access_token => params[:access_token],
			:fields       => "id,first_name,last_name,email,locale,picture,birthday,gender",
			:type         => "large"

		}
		fb_user = Settings.fb.url.to_uri.get(data).deserialize
	    user_attr = {:first_name=>fb_user["first_name"],:email=>fb_user["email"],:last_name=>fb_user["last_name"]}
        if User.find_by_email(user_attr[:email]).nil?
            user_attr[:password] = SecureRandom.hex(10)
            if user = User.create(user_attr)
	            auto_login user
	            Thread.new do
	              AppMailer.registration(user_attr[:password],user,"http://#{request.host}").deliver
	      	    end
	            json = {:success=>true}
            else
            	json = {:success=>false,:error=>t("user.data_error")}
            end
        else
        	auto_login User.find_by_email(user_attr[:email])
        	json = {:success=>true}
        end
        render :json => json
	end


end
