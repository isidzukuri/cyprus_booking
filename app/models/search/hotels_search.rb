class HotelsSearch
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations
  
  attribute :city,          :type => String
  attribute :place_code,    :type => String
  attribute :stars,         :type => String 
  attribute :lat,           :type => Float
  attribute :lng,           :type => Float
  attribute :arrival,      :type => Date ,   :default => 1.week.from_now.to_date
  attribute :departure,    :type => Date ,   :default => 2.weeks.from_now.to_date
  attribute :rooms_count,   :type => Integer, :default => 1
  attribute :results_count, :type => Integer, :default => 200
  nested_attribute :rooms,  :class_name => "HotelRoom"
  
  
  def to_api_hash
    search = {}
    self.rooms.each_with_index do  |room,i|
       a = "room#{(i+1)}"
       adults = room.adults.to_s
       childs = room.childs.times.collect{|e| room.child_age }.join(',')
       people = childs.size == 0 ? adults : adults + "," + childs 
       search.merge!(:"#{a}"=>people)
    end
    search.merge!(
      :arrivalDate   => self.arrival.strftime("%m/%d/%Y") ,
      :departureDate => self.departure.strftime("%m/%d/%Y"),
      :results_count => self.results_count,
      :maxStarRating => self.stars,
      :minStarRating => self.stars,
      #:latitude      => self.lat,
      #:longitude     => self.lng,
      :destinationId => self.place_code
    )
    search
  end

  def interval
     (departure - arrival).to_i 
  end
  
  
  def count_people
     count  = 0
    self.rooms.each  do |room|
      count += room.adults
      count += room.childs
    end
    count
  end

end
