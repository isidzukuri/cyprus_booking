ActionMailer::Base.smtp_settings = {

  :address              => "smtp.gmail.com",

  :port                 => 465,

  :domain               => "good-travel.ua",

  :user_name            => "info@good-travel.ua",

  :password             => "goodtravelbest",

  :authentication       => "plain",

  :tls                  => true, 
  
  :enable_starttls_auto => true

}

ActionMailer::Base.default_url_options[:host] = "good-travel.ua"