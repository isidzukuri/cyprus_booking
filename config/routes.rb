Cypr::Application.routes.draw do
  get 'admin',  to: "admin#index" 
  get 'logout', to: "users#exit"
  post "login",to: "users#auth"
  post "register", to: "users#register"
  post "restore", to: "users#forgot"
  get "fbregister",to:"users#fbregister"
  scope :path =>"(:locale)", :locale => /ru|ua|en/ do
    root :to => "home#index"
    get "hotels/show/:id" => "hotels#show"
    get "aparts/show/:id" => "aparts#show"
    get "hotels/load_hotels"
    post "hotels/booking/:id" => "hotels#booking"
    post "aparts/booking/:id" => "aparts#booking"
    post "hotels/book/:id" => "hotels#book"
    post "aparts/book/:id" => "aparts#book"

    get "hotels/pay"
    namespace :cabinet do 
        get :profile,to:"profile#show"
        get "offers/remove_photo",to:"offers#remove_photo"
        get "profile/edit",to:"profile#edit"
        put "profile/save",to:"profile#save"
        post "profile/save",to:"profile#save"
        resources :auto
        resources :offers
        resources :aparts
        resources :hotels
    end

    namespace "hotels" do
        %w(complete show booking results get_map_items).each do |action|
            get action
        end
    	post "search"
    	post "book"
    end
    namespace "avia" do
        %w(complete show booking results get_map_items).each do |action|
            get action
        end
        post "search"
        post "book"
    end
    namespace "cars" do
        %w(complete get_map_items show results dropp_off_open_time pick_up_open_time dropp_off_location dropp_off_city dropp_off_country pick_up_location pick_up_city).each do |action|
            get action
        end
    	post "search"
    	post "book"
    end
    get "cars/rules"
    get "cars/show/:id" => "cars#show"
    post "cars/booking/:id" => "cars#booking"
    post "cars/book/:id" => "cars#book"
    post "cars/pay"
    namespace "aparts" do
        %w(complete show results get_map_items).each do |action|
            get action
        end
        get "show/:id" => "aparts#show"
    	post "search"
    	post "book"
    end
    get "faq" ,to:"faq#index"
    get "faq/:seo" ,to:"faq#show"
  end






   namespace :admin do
     post "login_admin"
     post "users/pass_change"
     resources :users
     resources :emails 
     resources :transactions
     resources :facilities
     resources :apartaments
     resources :characteristics
     resources :currencies
     resources :nearbies
          resources :categories
     resources :pages
     get "apartaments",          to: "apartaments#index"
     get "apartaments/delete/:id",      to: "apartaments#delete"
     post "apartaments/upload_photos",  to: "apartaments#upload_photos"
     get "apartaments/remove_photo/:photo_id",  to: "apartaments#remove_photo"
     get "apartaments/remove_employment/:id",  to: "apartaments#remove_employment"
     get "apartaments/remove_price/:id",  to: "apartaments#remove_price"
     get "facilities",          to: "facilities#index"
     get "facilities/new",      to: "facilities#new"
     get "facilities/delete/:id",      to: "facilities#delete"
     get "nearbies/delete/:id",      to: "nearbies#delete"
     get "currencies/delete/:id",      to: "currencies#delete"
     get "characteristics",          to: "characteristics#index"
     get "characteristics/new",      to: "characteristics#new"
     get "characteristics/delete/:id",      to: "characteristics#delete"
     get "settings", to: "settings#index"
     post "settings/save"
   end






  
end
