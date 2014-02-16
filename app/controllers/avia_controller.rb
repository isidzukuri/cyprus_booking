class AviaController < ApplicationController

	def complete
		api.complete(params[:term])
	end


	private
	def api
		@api ||= Api::Avia.new(Settings.avia)
	end
end