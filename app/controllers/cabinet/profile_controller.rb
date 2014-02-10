class Cabinet::ProfileController < ApplicationController
	before_filter :require_login
   

	def show
      @active_tab  = 0
      @active_link = 0
      @codes       = Country.get_phones
      @current_code= Country.find_by_code($country_code).country_phone
	end
	def edit
      @active_tab  = 0
      @active_link = 1
	end
  def save
    current_user.update_attributes(params[:user])
    redirect_to "/#{I18n.locale}/cabinet/profile/"
  end
	private
    def set_layout
      @body_cls = "faq_page cabinet"
      @user = current_user
    end
end