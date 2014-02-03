Cypr::Application.routes.draw do
  scope :path =>"(:locale)", :locale => /ru|ua|en/ do
    root :to => "home#index"
    get "home/search"
    resource "user"
    namespace "hotels" do
        %w(complete results booking).each do |action|
            get action
        end
        get "show/:id" => "hotels#show"
    	post "search"
    	post "book"
    end
    namespace "cars" do
        %w(complete results show booking dropp_off_open_time pick_up_open_time dropp_off_location dropp_off_city dropp_off_country pick_up_location pick_up_city).each do |action|
            get action
        end
        get "show/:id" => "cars#show"
    	post "search"
    	post "book"
    end
    namespace "aparts" do
        %w(complete results).each do |action|
            get action
        end
        get "show/:id" => "aparts#show"
    	post "search"
    	post "book"
    end
    get "faq" ,to:"faq#index"
    get "page" ,to:"page#show"
  end
end
