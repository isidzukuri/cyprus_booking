class Admin::UsersController < AdminController
	before_filter :require_login
	def index
		per_page = 10
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		if !params[:type].nil? && params[:type].to_i == 1
			@users = Role.find_by_role_type(:admin).users
		else
			unless params[:email].nil?
				@users = User.where("email LIKE ?","#{params[:email]}%").paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
			else
				@users = User.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
			end
		end

	end

	def new
		@user  = User.new
		@roles = Role.all.map{|role| [role.name,role.id]}
		@pass  = SecureRandom.hex(10)
	end

	def create
		role = Role.find(params[:user].delete(:roles))
		user = User.new(params[:user])
		user.roles << role
		if user.valid?
			user.save
			flash[:notice] = t("user.actions.added")
			AppMailer.registration(params[:user][:password],user,request.domain).deliver
		else
			flash[:errors] = user.errors.messages
		end
		
		redirect_to admin_users_path
	end

	def edit
		@user = User.find(params[:id])
		@roles = Role.all.map{|role| [role.name,role.id]}
	end

	def update
		user = User.find(params[:id])
		role = Role.find(params[:user].delete(:roles))
		user.update_attributes(params[:user])
		user.roles = [role]
		if user.valid?
			user.save
			flash[:notice] = t("user.actions.changed")
		else
			flash[:errors] = user.errors.messages
		end
		redirect_to admin_users_path
	end

	def pass_change
		pass = params[:password] || SecureRandom.hex(10)
		user = User.find(params[:id].to_i)
		unless user.nil?
			user.change_password! pass
			AppMailer.password_change(pass,user,request.domain).deliver
			flash[:notice] = t("user.actions.pass_changed")
			redirect_to admin_users_path

		else
			flash[:error] = t("admin.users.not_exist")
		end
	end
end
