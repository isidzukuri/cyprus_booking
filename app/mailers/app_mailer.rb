class AppMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset_password_email user
    p user 
  end
  def password_change pass ,user ,domain
   	email_data = {
  		:name  		=> "#{user.last_name} #{user.first_name}",
  		:email 		=> user.email,
  		:pass   	=> pass,
  		:domain 	=> domain,
  		:updated_at => l(user.updated_at.to_date,:format=>:long)
  	}
  	set_email_template self.action_name , email_data 
  	mail(:to => "#{user.last_name} #{user.first_name} <#{user.email}>", :subject => I18n.t("mail.subjects.#{self.action_name}" , :domain=>domain) ,:template_name=>'base_template')
  end

  def registration pass ,user ,domain
   	email_data = {
  		:name  		=> "#{user.last_name} #{user.first_name}",
  		:email 		=> user.email,
  		:pass   	=> pass,
  		:domain 	=> domain,
  		:created_at => l(user.created_at.to_date,:format=>:long)
  	}
  	set_email_template self.action_name , email_data 
  	mail(:to => "#{user.last_name} #{user.first_name} <#{user.email}>", :subject => I18n.t("mail.subjects.#{self.action_name}" , :domain=>domain) ,:template_name=>'base_template')
  end

  def create_penalty penalty ,user ,domain
  	set_email_template self.action_name , email_data 
  	mail(:to => "#{user.last_name} #{user.first_name} <#{user.email}>", :subject => I18n.t("mail.subjects.#{self.action_name}" , :domain=>domain) ,:template_name=>'base_template')
  end

  def pay_penalty penalty ,user
  	set_email_template self.action_name , email_data 
  	mail(:to => "#{user.last_name} #{user.first_name} <#{user.email}>", :subject => I18n.t("mail.subjects.#{self.action_name}" , :domain=>domain) ,:template_name=>'base_template')
  end


  private
    def set_email_template action , data
    	@template = EmailTemplate.find_by_email_type(action)
    	data.each_pair do |key,v|
    		@template.html.gsub!("%#{key}%",v)
    	end
    end
end
