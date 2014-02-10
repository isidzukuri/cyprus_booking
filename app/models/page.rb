class Page < ActiveRecord::Base
  attr_accessible :name, :text,:name_en, :name_ru,:text_ru,:text_en,:category_id,:seo
  belongs_to :category
   def name=(name)
    write_attribute(:"name_#{I18n.locale}",name)
  end
  def name
    read_attribute("name_#{I18n.locale}")
  end
   def text=(text)
    write_attribute(:"text_#{I18n.locale}",text)
  end
  def text
    read_attribute("text_#{I18n.locale}")
  end
end
