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

end