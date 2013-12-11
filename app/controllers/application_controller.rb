class ApplicationController < ActionController::Base
  protect_from_forgery
  def initialize
    super
    @cls = ""
  end

  before_filter :set_currency
  before_filter :set_locale
  def set_currency
  	@currencies = Currency.all
    $currency   = cookies[:currency] || :USD
  end

  private
    def set_locale
      $country_code = "http://ip-api.com/json".to_uri.get.deserialize["countryCode"]
      I18n.locale = params[:locale] || I18n.default_locale
      Rails.application.routes.default_url_options[:locale] = I18n.locale 
    end
end
