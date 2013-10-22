class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_and_belongs_to_many :roles
  has_many :apartments_bookings
  has_many :friends
  has_many :messages
  has_many :rewievs
  has_many :received_messages, :foreign_key => "receiver", :class_name => "Message"


  validates :first_name, :presence => {:message=>I18n.t("user.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("user.errors.minimum_chars")}
  validates :email, :uniqueness => {:message=>I18n.t("user.errors.email_registered")}, :format => {:message=>I18n.t("user.errors.wrong_email"),:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  
  has_attached_file :file, 
  :url  => "/system/avatars/:id/:style.:extension",
  :path => ":rails_root/public/system/avatars/:id/:style.:extension",    
  :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['220x100',   :jpg],
      :medium   => ['450x285',    :jpg],
      :large    => ['500x500>',   :jpg],
      :cabinet  => ['100x100',   :jpg],
    }
  def modules
  	modules = []
  	self.roles.each do |role|
  		modules << role.admin_modules 
  	end
  	modules.flatten
  end

  def is_admin?
    self.roles.include?(Role.find_by_role_type(:admin))
  end

  def has_access?
  	self.active > 0
  end

  def fio
    "#{self.last_name} #{self.first_name} #{self.patronic}"
  end

  def address
    "#{self.city}, #{self.street},#{self.building}"
  end

end
