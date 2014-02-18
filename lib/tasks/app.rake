# encoding: UTF-8

namespace :app do

  desc "Insert cities data"
  task :cities_import => :environment do
  	del_query = Rails.env == "development" ? "DELETE FROM cities;" : "TRUNCATE TABLE cities;"
  	queries   = File.read("#{Rails.root}/db/cities.sql").split(";")
  	ActiveRecord::Base.connection.execute del_query
  	queries.each do |query|
  		ActiveRecord::Base.connection.execute query
  	end
  end
  desc "Insert countries data"
  task :countries_import => :environment do
  	del_query = Rails.env == "development" ? "DELETE FROM countries;" : "TRUNCATE TABLE countries;"
  	queries   = File.read("#{Rails.root}/db/countries.sql").split(";")
  	ActiveRecord::Base.connection.execute del_query
  	queries.each do |query|
  		ActiveRecord::Base.connection.execute query
  	end
  end

  desc "Insert cypr cars locations"
  task :cars_cities_import => :environment do
    del_query = Rails.env == "development" ? "DELETE FROM car_cities;" : "TRUNCATE TABLE car_cities;"
    ActiveRecord::Base.connection.execute del_query
    del_query = Rails.env == "development" ? "DELETE FROM car_city_locations;" : "TRUNCATE TABLE car_city_locations;"
    ActiveRecord::Base.connection.execute del_query
    {ru:"Кипр",en:"Cyprus"}.each_pair do |lang,name|
      api.prefered.merge!(preflang:lang)
      data = api.get_city_list name
      next if data.kind_of?(Array) and data.size == 0
      (data.kind_of?(String) ? [data] : data).each do |n|
        city = CarCity.create(name:n.force_encoding("UTF-8"),country_id:country_id,lang:lang)
        city.update_attributes(get_coords(n.force_encoding("UTF-8")))
        data = api.get_location_list name , n
        data.each do |c|
          city_loc = CarCityLocation.create(country_id:country_id,car_city_id:city.id,location_id:c[:id],name:c[:name].force_encoding("UTF-8"),lang:lang)
          city_loc.update_attributes(get_coords(c[:name].force_encoding("UTF-8")))
        end
      end
    end
  end

  desc "Insert cypr hotel locations"
  task :hotel_location_import => :environment do
    del_query = Rails.env == "development" ? "DELETE FROM hotel_locations;" : "TRUNCATE TABLE hotel_locations;"
    ActiveRecord::Base.connection.execute del_query 
    File.read("#{Rails.root}/db/hotel_cities.txt").split("\n").each do |row|
      row = row.split("|")
      next unless row.at(1).match(/Cyprus/)
      loc = HotelLocation.create(country_id:country_id,lang:"en",code:row.first,name_en:row.at(1).split(",").first)
      loc.update_attributes(get_coords(row.at(1)))
    end
    HotelLocation.all.each do |loc|
       %w(ru).each do |lang|
          sleep 2
          name = name_by_coords(loc.name_en,lang)
          loc.update_attributes({:"name_#{lang}"=>name})
       end
    end
  end

  desc "Import Hotel Data"
  task :import_ean_hotels => :environment do
    del_query = Rails.env == "development" ? "DELETE FROM hotels;" : "TRUNCATE TABLE hotels;"
    ActiveRecord::Base.connection.execute del_query 
    codes = HotelLocation.all.map{|l| l.code}
    File.read("#{Rails.root}/db/ean_hotels.txt").split("\n").each do |row|
      row = row.split("|")
      next if row.at(20).nil?
      next unless codes.include?(row.at(20).to_i)
      hotel = {
        :hotel_id => row.at(0),
        :name => row.at(2),
        :address => row.at(3),
        :lat => row.at(9).nil? ? 0 : row.at(9).to_f,
        :lng => row.at(10).nil? ? 0 : row.at(10).to_f,
        :stars => row.at(14).nil? ? 0 : row.at(14).to_f,
        :check_in => row.at(23),
        :check_out => row.at(24),
        :currency => row.at(13),
        :hight_rate =>  row.at(21).nil? ? 0 : row.at(21).to_f,
        :low_rate =>  row.at(22).nil? ? 0 : row.at(22).to_f,
        :hotel_location_id => row.at(20).nil? ? 0 : HotelLocation.find_by_code(row.at(20).to_i).id,
      }
      Hotel.create(hotel)
    end   
    # codes = Hotel.all.map{|l| l.hotel_id}
    # File.read("#{Rails.root}/db/ean_hotel_images.txt").split("\n").each do |row|
    #   row = row.split("|")
    #   next unless codes.include?(row.first.to_i)
    #   hotel = Hotel.find_by_hotel_id(row.first.to_i)
    #   p hotel
    #   hotel.update_attributes({:image_url=>row.at(2)})
    # end
  end

  desc "Import Airports"
  task :import_airports => :environment do
    del_query = Rails.env == "development" ? "DELETE FROM airports;" : "TRUNCATE TABLE airports;"
    queries   = File.read("#{Rails.root}/db/airports.sql").split(";")
    ActiveRecord::Base.connection.execute del_query
    queries.each do |query|
      ActiveRecord::Base.connection.execute query
    end
  end

end

def api
  @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
end

def get_coords address
  data = "http://maps.google.com/maps/api/geocode/json".to_uri.get(address:CGI.unescape(address),sensor:false).deserialize
  if data["status"]!="ZERO_RESULTS"
    data =  data["results"].first["geometry"]["location"]
    {:lat=>data["lat"],:lng=>data["lng"]}
  else
    {}
  end
end

def name_by_coords address,lang
  data = "http://maps.google.com/maps/api/geocode/json".to_uri.get(address:CGI.unescape(address),sensor:false,language:lang).deserialize
  if data["status"]!="ZERO_RESULTS"
    data["results"].first["address_components"].first["short_name"]
  else
    address
  end
end

def country_id
   Country.find_by_code("CY").id
end