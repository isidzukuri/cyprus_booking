class PaymentDetail < ActiveRecord::Base
  attr_accessible :bank_id, :budget_code, :budget_code_name, :edrpo, :name_ru, :name_ua, :payment_number, :region_id
  validates :budget_code_name, :inclusion => { :in => %w(first) }
  validates :name_ru, :name_ua, :budget_code_name, :edrpo, :payment_number, :presence => {:message=>I18n.t("user.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("user.errors.minimum_chars")}

  belongs_to :region
  belongs_to :bank

  def name
    read_attribute("name_#{I18n.locale}")    
  end  

end
