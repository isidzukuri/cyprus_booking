class Employment < ActiveRecord::Base
  # attr_accessible :name_ru, :name_uk, :name_en

  belongs_to :house

  ############# STATUSES #############
  # 1 - reserved by owner
  # 2 - reserved by client
  # 3 - payed by client
  # 0, nil - available

end
