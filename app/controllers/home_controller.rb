class HomeController < ApplicationController
  
  def index
  	setup_models
    @pick_up_countries = cars_countries
  end

  def change_lang
  	
  end

  def change_currency
  	
  end

  private

  def setup_models
  	@hotels_search = HotelSearch.new(rooms:[HotelRoom.new(adult:[HotelAdult.new],child:HotelChild.new)])
  	@cars_search   = CarsSearch.new(:pick_up => CarsLocation.new , :dropp_off=>CarsLocation.new , :driver_age=>nil)
  	@apart_search  = ApartSearch.new 
    @top_search    = TopSearch.new(rooms:[HotelRoom.new(adult:[HotelAdult.new],child:HotelChild.new)])
  end

  def get_locations
    {
      apart_cities: City.all.map(&:to_map)
      hotel_cities: HotelLocation.where(lang:I18n.locale).all.map(&:to_map)
      cars_cities:  CarCity.where(lang:I18n.locale).all.map(&:to_map)
    }
    
    
    
  end

end
