class AviaController < ApplicationController

	def complete
		render :json => api.complete(params[:filter])
	end

	def search
		search = AviaSearch.new(params[:avia_search])
		data = api.search(search.to_api_hash)
		session_id = Digest::MD5.hexdigest(search.to_s)
 		Rails.cache.write("avia_search_result_"+session_id, data, :expires_in => 1.hour)
      	Rails.cache.write("avia_search_query_" +session_id, search, :expires_in => 1.hour)
      	render :json => {success:true,map_search:false,url:avia_results_path(session_id:session_id)}
	end

	def results
		AviaSearch.new
		@search  = Rails.cache.read("avia_search_query_" +params[:session_id])
		@results = Rails.cache.read("avia_search_result_"+params[:session_id])
		p @results["tickets"].first
		#raise
		@url     = api.book_url
	end



	private
	def api
		@api ||= Api::Avia.new(Settings.avia)
	end
    def set_layout
      @body_cls = "car_page"
    end
end