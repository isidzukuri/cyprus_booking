class CarsBookingEdit
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations
  attribute :reservation_id
  attribute :car_name
  attribute :car_code
  attribute :pick_day
  attribute :pick_month
  attribute :pick_year
  attribute :pick_hour
  attribute :pick_minute
  attribute :dropp_day
  attribute :dropp_month
  attribute :dropp_year
  attribute :dropp_hour
  attribute :dropp_minute
  attribute :flight_number
  attribute :driver_name
  attribute :driver_surename
  attribute :driver_email
  attribute :driver_phone
  attribute :driver_address
  attribute :driver_city
  attribute :driver_country
  attribute :driver_postal
  attribute :same_place
  attribute :comment
  nested_attribute :pick_up,   :class_name => "CarsLocation"
  nested_attribute :dropp_off, :class_name => "CarsLocation"
  
  
  
  def to_normal
    pick_date   = "#{self.pick_day}-#{self.pick_month}-#{self.pick_year}"
    pick_time   = "#{self.pick_hour}:#{self.pick_minute}"
    drop_date   = "#{self.dropp_day}-#{self.dropp_month}-#{self.dropp_year}"
    drop_time   = "#{self.dropp_hour}:#{self.dropp_minute}"
    driver_name = "#{self.driver_name} #{self.driver_surename}"
    result = {
      :pick    => {:date  => pick_date,
                   :time  => pick_time,
                   :other => self.pick_up
      },
      :drop    => {:date  => drop_date,
                   :time  => drop_time,
                   :other => self.dropp_off
      },
      :driver  => {:name  => driver_name,
                   :email => self.driver_email,
                   :phone => self.driver_phone,
                   :other => "#{self.driver_country}  #{self.driver_city} #{self.driver_postal} #{self.driver_address}"
      },
      :vehicle => {:name  => self.car_name,
                   :code  => self.car_code
      },
      :flight_number  => self.flight_number,
      :comment        => self.comment,
      :reservation_id => self.reservation_id,
    }
    return result
  end
  
end