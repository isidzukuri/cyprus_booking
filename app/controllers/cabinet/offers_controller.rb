class Cabinet::OffersController < ApplicationController
    
    def index
    	
    end
	def new
		@offer      = House.new
		@facilities_ids = []
		set_data
	end
	def get_coords address
		data = "http://maps.google.com/maps/api/geocode/json".to_uri.get(address:CGI.unescape(address),sensor:false).deserialize
		if data["status"]!="ZERO_RESULTS"
			data =  data["results"].first["geometry"]["location"]
			{:latitude=>data["lat"],:longitude=>data["lng"]}
		else
			{}
		end
	end
	def create
		facilities = params[:house].delete(:facilities)
		offer  = House.new(params[:house])
		if offer.valid?
			offer.user = current_user
			offer.save
			data = get_coords(offer.full_address)
			offer.update_attributes(data)
			redirect_to edit_cabinet_offer_path(offer.id)
		else
			redirect_to new_cabinet_offer_path
		end

	end
	def edit
		@offer  = current_user.houses.find(params[:id])
		@facilities_ids = @offer.facilities.map(&:id)
		set_data
	end
	def update
		offer  = current_user.houses.find(params[:id])
		facilities =  params[:house].delete(:facilities)[:id].each_pair.map{|f,g| g.to_i == 1 ? f.to_i : nil}.compact
		facilities = Facility.find(facilities)
		offer.update_attributes(params[:house])
		offer.facilities = facilities
		data = get_coords(offer.full_address)
		offer.update_attributes(data)
		offer.save
		redirect_to edit_cabinet_offer_path(offer.id)
	end
	def remove_photo
		json = {:success=>true}
		offer = current_user.houses.find(params[:id])
		photo = offer.photos.find(params[:photo_id])
		photo.delete
	rescue
		json = {:success=>false}
	ensure
		render :json=>json
	end

	private
	def set_data
		@cities     = City.all.map{|c| [c.name,c.id]}
		@countries  = Country.all.map{|c| [c.name,c.id]}
		@facilities = Facility.all.in_groups_of(Facility.count/2)
		@currencies = Currency.all.map{|c| [c.title,c.id]}
		@flat_types = I18n.t("all.flat_types").each_pair.map{|g,h| [h,g.to_s.gsub("type_","")]}
	end
    def set_layout
      @body_cls = "faq_page cabinet offer"
      @active_tab  = 3
      @active_link = 2
    end
end