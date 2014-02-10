class Category < ActiveRecord::Base
  attr_accessible :name_ru,:name_en,:parent_id,:name,:seo
  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category"
  has_many :pages, :dependent => :destroy

   def name=(name)
    write_attribute(:"name_#{I18n.locale}",name)
  end
  def name
    read_attribute("name_#{I18n.locale}")
  end
end