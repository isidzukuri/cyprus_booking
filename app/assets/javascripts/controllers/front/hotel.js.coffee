$.Controller "HotelItemController",
  init: ->
    @init_rating()  
    @set_photos_slider()
    @start_left_offset = @element.find(".list")
    @enable_left  = true
    @enable_right = true

  init_rating: ->
    url = ""
    @element.find(".header_name .rating").rating url ,
      curvalue: 3
  set_photos_slider: ->
    ph_count   = @element.find(".photos img").size()
    f_ph_count = Math.floor(ph_count/5) 
    if f_ph_count > 0 && ph_count >= 5
      width = (990 * f_ph_count) + ((ph_count - (f_ph_count * 5)) * 640)
    else
      width = ph_count * @element.find(".photos img").last().width() + 100
      
    @element.find(".list").width(width)
    @element.find(".navigation").show() if ph_count > 5
    @element.find(".list img").each (i,el) ->
      $(el).wrap($("<a rel='slider' href=" + $(el).attr("src").replace("medium","original") + ">"))
    $("a[rel=slider]").fancybox
      transitionIn: "none"
      transitionOut: "none"
      titlePosition: "over"
      titleFormat: (title, currentArray, currentIndex, currentOpts) ->
        "<span id=\"fancybox-title-over\">Image " + (currentIndex + 1) + " / " + currentArray.length + ((if title.length then " &nbsp; " + title else "")) + "</span>"

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

  add_to_wish: (el) ->


  ".form-submit -> click":(ev)->
    ev.preventDefault()
    unless window.logged_in
      show_notice I18n.notice, I18n.user.login
    else
      form = $(ev.target).next().submit()