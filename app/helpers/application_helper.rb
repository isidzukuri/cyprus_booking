module ApplicationHelper

  def book_steps(steps, current = 0)

  	content_tag :div, :class => 'steps' do
	    content_tag :ul  do
	      steps.each_with_index.map do |txt, i|
	        content_tag :li , :class=>("last" if i == steps.size - 1 ) do
	        	content_tag(:span,(i+1),:class=>[("past" if current > i),("active" if current == i),"number"].compact  ) + content_tag(:span,txt,:class=>[("past" if current > i),("active" if current == i),"steps_lable"].compact )
	        end
	      end.join("").html_safe
	    end
	end

  end

  def exchange total,currency
    (Exchange.convert(currency, $currency) * total).round(2)
  end

  def rating_display value = 3.0
  	rating = []
  	5.times do |i|
  		rating << tag(:input , {:class=>"star", :type=>"radio" ,:name=>"star",:disabled=>"disabled" })
  	end
  	rating << tag(:input , {:name=>"val", :type=>"hidden" ,:value=>value})
  	rating.join("").html_safe
  end

  def photos_min_dispay photos
  	count = photos.count
  	photo_html = case count
  	when 0
  		_render_one_photo
  	when 1
  		_render_one_photo photos.first
  	when 2
  		_render_one_photo photos.first
  	else		
  		_render_thre_photo photos
  	end
  end




  def _render_one_photo photo = nil
  	image_tag ( photo.nil? ? "#{Rails.root}/public/missings/apart_main.jpg" : photo.file(:medium)) ,:size=>"450x285" ,:style=>"margin: 8px;"
  end

  def _render_thre_photo photos
  	first = photos.shift
  	content = [image_tag(first.file(:medium) ,:size=>"447x285" ,:style=>"margin: 8px;")]
  	photos.shift(2).each do |photo|
  		content << image_tag( photo.file(:small) ,:style=>"margin-left: 8px;")
  	end
  	content.join("").html_safe
  end


  def render_photos photos
    content = []
    if photos.count >= 5
      size       = (photos.count/5)
      big_photos = photos.pop(size)
      photos_    = photos.in_groups_of(4,false)
      big_photos << photos_.last if photos_.last.size < 4
      big_photos.flatten!
      size.times do |i|
        content << content_tag(:div,:class=>"small_images") do 
          photos_.shift.map do |photo|
            image_tag( photo.file(:medium) ,:style=>"margin-right: 8px;margin-bottom: 8px;",:size=>"167x120")
          end.join("").html_safe
        end
        content<< content_tag(:div,:class=>"big_image")do
          image_tag( big_photos.shift.file(:medium) ,:size=>"627x250",:style=>"margin-right: 8px;")
        end
      end
      big_photos.each do |photo|
        content<< content_tag(:div,:class=>"big_image")do
          image_tag( photo.file(:medium) ,:size=>"627x250",:style=>"margin-right: 8px;")
        end
      end
    else
      photos.each do |photo|
        content << image_tag( photo.file(:medium) ,:size=>"627x250",:style=>"margin-right: 8px;")
      end
    end
    content.join("").html_safe
  end


  def render_hotel_photos photos
    content = []
    if photos.count >= 5
      size       = (photos.count/5)
      big_photos = photos.pop(size)
      photos_    = photos.in_groups_of(4,false)
      big_photos << photos_.last if photos_.last.size < 4
      big_photos.flatten!
      size.times do |i|
        content << content_tag(:div,:class=>"small_images") do 
          photos_.shift.map do |photo|
            image_tag( photo[:big] ,:style=>"margin-right: 8px;margin-bottom: 8px;",:size=>"167x120")
          end.join("").html_safe
        end
        content<< content_tag(:div,:class=>"big_image")do
          image_tag( big_photos.shift[:big] ,:size=>"627x250",:style=>"margin-right: 8px;")
        end
      end
      big_photos.each do |photo|
        content<< content_tag(:div,:class=>"big_image")do
          image_tag( photo[:big] ,:size=>"627x250",:style=>"margin-right: 8px;")
        end
      end
    else
      photos.each do |photo|
        content << image_tag( photo[:big] ,:size=>"627x250",:style=>"margin-right: 8px;")
      end
    end
    content.join("").html_safe
  end




  def render_reviews_rating apartment
    content = []
    Characteristic.all.each do |chr|
      content << content_tag(:div,chr.name,:class=>"text")
      content << content_tag(:div,:class=>"characteristicks rating",:"data-value"=>(chr.houses.include?(apartment) ? apartment.ratings.map{|r| r.characteristic == chr ? r : nil}.compact.first.value : 0)) do
        arr = 5.times.map do |i|
           tag(:input , {:class=>"star", :type=>"radio" ,:name=>"star",:disabled=>"disabled" })
        end.join("").html_safe
      end
    end
    content.join("").html_safe
  end

end
