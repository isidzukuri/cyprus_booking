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

  desc "Cache cypr cars locations"

  desc "Task description"
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
        city = CarCity.create(name:n,country_id:50,lang:lang)
        data = api.get_location_list name , n
        data.each do |c|
          CarCityLocation.create(country_id:50,car_city_id:city.id,location_id:c[:id],name:c[:name],lang:lang)
        end
      end
    end
  end

end


  def api
    @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
  end