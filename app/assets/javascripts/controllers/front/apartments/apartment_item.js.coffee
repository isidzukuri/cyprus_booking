$.Controller "ApartmentItemController",
  init: ->
    @init_rating()  
    @set_photos_slider()
    @init_rewiew_rating()
    @start_left_offset = @element.find(".list")
    @enable_left  = true
    @enable_right = true

  init_rating: ->
  	url = ""
  	@element.find(".header_name .rating").rating url ,
  	  curvalue: 3
  init_rewiew_rating: ->
  	@element.find(".characteristicks.rating").each (i,el) ->
  	  $(el).rating "#" ,
  	    curvalue: $(el).data("value")
  	@element.find(".characteristicks").each (i,el) ->
  	  prev = $(el).prev()
  	  $(el).wrap(prev,$("<div class='rating_wrapper'>"))
  	  prev.remove()
  set_photos_slider: ->
    ph_count   = @element.find(".photos img").size()
    f_ph_count = Math.round(ph_count/5) 
    if f_ph_count > 0
      width = (980 * f_ph_count) + ((ph_count - (f_ph_count * 5)) * 640)
      @element.find(".list").width(width)
    @element.find(".navigation").show() if ph_count > 5

  ".navigation -> click":(ev)->
    ev.preventDefault()
    offset = 500
    left_offset  = @element.find(".list").offset().left
    start_offset = @element.find(".photos").offset().left
    last_img     = @element.find(".photos img").last()
    self = @
    if $(ev.target).hasClass("btn-prev")
      @set_right(true)
      return unless @enable_left
      return if start_offset == left_offset
      offset = if left_offset + offset > start_offset then offset - left_offset - start_offset  else offset
      @set_left(false)
      @element.find(".list").animate
        left: "+=" + offset + "px"
      , "slow"
      ,
      ->
      	self.set_left(true)
    else
      @set_left(true)
      return unless @enable_right
      ph = last_img.offset().left - last_img.width()
      offset = if ph < offset then ph else offset
      @set_right(false)
      @element.find(".list").animate
        left: "-=" + offset + "px"
      , "slow"
      ,
      ->
      	self.set_right(true)

  set_left: (type)->
  	@enable_left = type
  set_right:(type)->
  	@enable_right = type