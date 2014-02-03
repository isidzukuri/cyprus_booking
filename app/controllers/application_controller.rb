class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery
  before_filter :set_locale
  before_filter :set_currency
  before_filter :set_user

  protected

  def cars_countries
    countries = Rails.cache.fetch("cars_countries", :expires_in => 1.month) do
		  api.get_county_list.collect{|c| [ c, c ] }
    end
  end

  private
  
  def set_currency
  	@currencies = Currency.all
    $currency   = cookies[:currency] || :USD
  end

  def api
    @api ||= Api::Cars.new(Settings.auto_api.host,Settings.auto_api.user,Settings.auto_api.pass,Settings.auto_api.ip)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end

  def set_user
    @user = User.new unless logged_in?
  end
end
