class CarsBookingsPayed < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :status, :car_location , :user,:reservation_id ,:vehicle_id , :car_name, :base_price , :protect, :protect_price , :pick_country , :pick_city , :pick_place ,:pick_location , :pick_date, :pick_time , :drop_country , :drop_city , :drop_place ,:drop_location , :drop_date, :drop_time , :driver_name , :driver_surname,:driver_birthday

  
  
  def set_data booking , order ,user
    #self.status          = 1
    self.user_id         = user.id
    self.reservation_id  = order
    self.vehicle_id      = booking.vehicle_id.to_i
    self.car_name        = booking.car_name
    self.base_price      = booking.car_price.to_f
    self.pick_country    = booking.pick_up.country
    self.pick_city       = booking.pick_up.country
    self.pick_place      = booking.pick_up.city
    self.pick_location   = booking.pick_up.location
    self.pick_date       = booking.pick_up.date.to_date
    self.pick_time       = booking.pick_up.time
    self.drop_country    = booking.dropp_off.country
    self.drop_city       = booking.dropp_off.country
    self.drop_place      = booking.dropp_off.city
    self.drop_location   = booking.dropp_off.location
    self.drop_date       = booking.dropp_off.date.to_date
    self.drop_time       = booking.dropp_off.time
    self.driver_name     = booking.driver.name
    self.driver_surname  = booking.driver.surname
    self.driver_birthday = "#{booking.driver.birthday_day}-#{booking.driver.birthday_month}-#{booking.driver.birthday_year}"
    
    check_car_protection booking.extras
    count_total_price
  end

  private
    def check_car_protection extras
      extras.each do |t|
        franc = t.name == I18n.t('auto.franchize') ? true : false
        if franc
          self.protect = 1
          self.protect_price = t.day_price.to_f
          break
        end
      end 
    end
    
    
    def count_total_price
      
     
      
    end
  
  
end
