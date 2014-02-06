class Admin::EmailsController < AdminController
	before_filter :require_login
	def index
		@emails = EmailTemplate.all
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