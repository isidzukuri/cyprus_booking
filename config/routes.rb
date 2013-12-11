CyprusBooking::Application.routes.draw do
   get 'admin',  to: "admin#index" 
   get 'logout', to: "user#exit"
   match "login",to: "user#enter", via:[:post]
   match "login",to: "home#login", via:[:get]

scope "(:locale)", :locale => /en|ru/ do
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

   namespace :user do
    post "auth"
    post "forgot"
    post "register"
    post "fbregister"
   end
   get     "cabinet/hotels/booking_cancel"
   namespace :cabinet do
    resources :houses
    resources :offers
    resources :messages
    resources :whishes
    resources :hotels
    get  "offers/:id/delete", to: "offers#destroy"

    
    resources "profile", :only=>[:show]
    post "index/filter",  to: "houses#houses_filter"
    post "houses/:id/upload_photos" ,  to: "houses#upload_photos"
    get "houses/:id/delete_photo" ,  to: "houses#delete_photo"
    
   end

  
     root :to => "home#index"


     get "apartments/complete"
     get "hotels/complete"
     get "cars/complete"
     get "yahts/complete"


     match "apartments", to: "apartments#index",  via: :get
     match "apartments", to: "apartments#search", via: :post
     match "hotels",     to: "hotels#index",  via: :get
     match "hotels",     to: "hotels#search", via: :post
     match "cars",       to: "cars#index",  via: :get
     match "cars",       to: "cars#search", via: :post
     match "yahts",      to: "yahts#index",  via: :get
     match "yahts",      to: "yahts#search", via: :post

     get  "apartments/show/:id", to: "apartments#show"
     get  "apartments/show_index"
     get  "apartments/get_prices"
     get  "apartments/refresh_price"
     get  "apartments/remove_from_wish"
     post "apartments/pay"
     get  "hotels/show/:id",     to: "hotels#show"
     get  "cars/show/:id",       to: "cars#show"
     get  "yahts/show/:id",      to: "yahts#show"



     match "apartments/booking/:id", to: "apartments#booking"
     match "hotels/booking/:id",     to: "hotels#booking"
     match "cars/booking/:id",       to: "cars#booking"
     match "yahts/booking/:id",      to: "yahts#booking"


     post   "apartments/hotels"
     post   "apartments/cars"
     post   "apartments/yahts"
     
     get    "apartments/to_wish"
     get    "yahts/to_wish"
     get    "hotels/get_advanced_form"
     get    "hotels/get_hotel_info"
     get    "hotels/info"
     post    "hotels/booking"
     post    "hotels/pay"
     get     "hotels/create_booking"
     get     "cabinet/hotels/booking_cancel"
     
     match "change_currency", to: "home#change_currency"

     
   end
    get 'error',  :to => 'home#routing'
    match '*a',   :to => 'home#routing'
end
