class Cabinet::ApartsController < ApplicationController

	def index
			
	end	
	def show
		
	end
	def edit
		
	end

	private
    def set_layout
      @body_cls = "faq_page cabinet"
      @active_tab  = 1
      @active_link = 0
    end
end