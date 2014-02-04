class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery
  before_filter :set_locale
  before_filter :set_currency
  before_filter :check_ip
  before_filter :set_popup_data

  protected

  def cars_countries
    countries = Rails.cache.fetch("cars_countries", :expires_in => 1.month) do
		  api.get_county_list.collect{|c| [ c, c ] }
    end
  end

  private
  
  def set_currency
  	if params[:currency].present? && Settings.avail_currencies.include?(params[:currency])
      cookies[:currency] = params[:currency]
    end
    $currency   = cookies[:currency] || :USD
  end

  def api
    @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end

  def check_ip
    data = "http://ip-api.com/json".to_uri.get.deserialize
    $country_code = data["status"] == "success" ? data["countryCode"] : "RU"
  end

  def set_popup_data
    unless logged_in?
      @codes       = Country.get_phones
      @current_code= Country.find_by_code($country_code).country_phone
      @user = User.new 
      @restore = Restore.new
    end
  end
end
