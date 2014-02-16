class HomeController < ApplicationController
  
  def index
  	setup_models
    @pick_up_cities    = CarCity.where(lang:I18n.locale).all.map{|c|[c.name,c.id]}
    @hotel_cities      = HotelLocation.all.map{|c|[c.name,c.id]}
    @cities            = City.all.map{|c|[c.name,c.id]}
    @locations         = get_locations
  end

  def change_lang
  	
  end

  def change_currency
  	
  end

  private

  def setup_models
  	@hotels_search = HotelSearch.new(rooms:[HotelRoom.new(adult:[HotelAdult.new],child:HotelChild.new)])
  	@cars_search   = CarsSearch.new(:pick_up => CarsLocation.new(country:Country.find_by_code("CY").name) , :dropp_off=>CarsLocation.new(country:Country.find_by_code("CY").name) , :driver_age=>nil)
  	@apart_search  = ApartSearch.new 
    @top_search    = TopSearch.new(rooms:[HotelRoom.new(adult:[HotelAdult.new],child:HotelChild.new)])
  end

  def get_locations
    {
      :apart_cities => City.all.map(&:to_map),
      :hotel_cities => HotelLocation.all.map(&:to_map),
      :cars_cities =>  CarCity.where(lang:I18n.locale).all.map(&:to_map)
    }
  end

end
