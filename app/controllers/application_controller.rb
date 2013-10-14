class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_currency
  def set_currency
  	@currencies = Currency.all
    $currency   = cookies[:currency] || :USD
  end
end
