class Penalty < ActiveRecord::Base
  attr_accessible  :has_invoice,:user_attributes,:protocol_penalty, :protocol_number,:protocol_serial,:protocol_date, :total_cost, :user_id, :payment_detail_id
  belongs_to :user
  belongs_to :payment_detail
  has_one :transaction

  validates_uniqueness_of :protocol_number ,:scope=> [:protocol_serial,:user_id,:protocol_penalty,:payment_detail_id]

  accepts_nested_attributes_for :user

  #before_create :set_total

  def appoitment
  	"#{self.payment_detail.budget_code};#{self.protocol_serial};#{self.protocol_number}"
  end

  def number
  	"#{self.protocol_serial} #{self.protocol_number}"
  end

  def to_api_desc
    "*;#{appoitment};#{self.user.fio};*"
  end

  def set_total
    self.total_cost =  has_invoice > 0 ? (protocol_penalty + PaymentManager.new.invoice_price ) : protocol_penalty
  end

end
