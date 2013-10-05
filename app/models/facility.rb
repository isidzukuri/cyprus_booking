class Facility < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :name_ru, :name_uk, :name_en, :seo

  # has_many :penalties
  has_and_belongs_to_many :houses

  validates :name_uk,:name_ru, :name_en,   :presence => {:message=>I18n.t("facilities.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("facilities.errors.minimum_chars")}
  validates :seo, :uniqueness => {:message=>I18n.t("facilities.errors.not_unique")}, :format => {:message=>I18n.t("facilities.errors.wrong"),:with => /^[a-zA-Z0-9.-]+$/}


end
