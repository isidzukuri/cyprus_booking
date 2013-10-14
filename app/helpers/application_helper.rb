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
  	photos.each do |photo|
  		content << image_tag( photo.file(:small) ,:style=>"margin-left: 8px;")
  	end
  	content.join("").html_safe
  end

end
