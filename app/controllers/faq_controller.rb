class FaqController < ApplicationController

	def index
			@page = Category.where(seo:"faq").first.pages.first
			 @seo = @page.seo
	end	
	def show
		@page = Page.where(seo:params[:seo]).first
		 @seo = @page.seo
	end
    def set_layout
      @body_cls = "faq_page cabinet"
      @active_tab  = 0
      @active_link = 0
    end
end