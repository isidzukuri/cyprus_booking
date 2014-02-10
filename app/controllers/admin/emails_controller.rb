class Admin::EmailsController < AdminController
	before_filter :require_login
	def index
		per_page = 20
		sort = params[:sort] || :id
		@dir = params[:dir] == 'DESC' ? 'ASC' : 'DESC'
		@emails = EmailTemplate.paginate(:per_page=>per_page,:page => params[:page]).order("#{sort} #{@dir}")
	end
	def edit
		@email = EmailTemplate.find(params[:id])
		@vars  = t("mail.vars.#{@email.email_type}")
	end

	def update
		email = EmailTemplate.find(params[:id])
		email.html=params[:email_template][:html]
		email.save
		flash[:notice] = t("admin.emails.changed")
		redirect_to admin_emails_path
	end

end