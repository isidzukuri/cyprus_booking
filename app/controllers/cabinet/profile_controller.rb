class Cabinet::ProfileController < ApplicationController
	before_filter :require_login
   

	def show
      @active_tab  = 0
      @active_link = 0
	end
	def edit
      @active_tab  = 0
      @active_link = 1
	end
	private
    def set_layout
      @body_cls = "faq_page cabinet"
      @user = current_user
    end
end