$.Controller "ApartmentItemController",
  init: ->
    @init_rating()  
    @set_photos_slider()
    @init_rewiew_rating()
    @start_left_offset = @element.find(".list")
    @enable_left  = true
    @enable_right = true
    @calendar = @element.find('.b_calendar').attachCalendarController().controller();
    self = @
    @element.find(".icon_date input").datepicker
      dateFormat: "dd.mm.yy"
      minDate: 0
      onSelect: (selected) ->
        idx = ($(".icon_date input").index($(this)) + 1)
        if $(".icon_date input").size() >= idx
          next_dp = $(".icon_date input:eq(" + idx + ")")
          next_dp.datepicker "option", "minDate", selected
          next_dp.datepicker "setDate", selected
        if idx == 2
          self.change_price()

  change_price: ->
    self = @
    $.ajax
      url:"/apartments/refresh_price"
      beforeSend: ->
        show_loader I18n.aparts.price_change
      data: id:self.element.data("id"),arrival:self.element.find(".icon_date input:eq(0)").val(),departure:self.element.find(".icon_date input:eq(1)").val()
      success: (resp) ->
        if(resp.changed)
          hide_loader()
          self.element.find(".header_name .price span:eq(0)").text(resp.price)
        else
          if resp.busy
            show_notice(I18n.notice,I18n.aparts.aparts_busy)
          else
            show_notice(I18n.error,I18n.aparts.apart_price_error)
  init_rating: ->
  	url = ""
  	@element.find(".header_name .rating").rating url ,
  	  curvalue: 3
  init_rewiew_rating: ->
  	@element.find(".characteristicks.rating").each (i,el) ->
  	  $(el).rating "#" ,
  	    curvalue: $(el).data("value")
    @element.find(".header_name .rating").each (i,el) ->
      $(el).rating "#" ,
        curvalue: $(el).data("value")
  	@element.find(".characteristicks").each (i,el) ->
  	  prev = $(el).prev()
  	  $(el).wrap(prev,$("<div class='rating_wrapper'>"))
  	  prev.remove()
  set_photos_slider: ->
    ph_count   = @element.find(".photos img").size()
    f_ph_count = Math.floor(ph_count/5) 
    if f_ph_count > 0 && ph_count >= 5
      width = (980 * f_ph_count) + ((ph_count - (f_ph_count * 5)) * 640)
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
  remove_from_wish: (el) ->
    $.ajax
      url: "/apartments/remove_from_wish",
      type: "get"
      success: (resp) ->
        if resp.success
           window.location.reload()
        else
          alert("error") 
  add_to_wish: (el) ->
    $.ajax
      url: "/apartments/to_wish",
      type: "get"
      success: (resp) ->
        if resp.success
          window.location.reload()
        else
          alert("error")

  ".buttons a -> click":(ev)->
    el = $(ev.target)
    if el.hasClass("wish")
      ev.preventDefault()
      if el.hasClass("disable")
        @remove_from_wish() 
        return
      if window.logged_in
        @add_to_wish(el)
      else
        show_notice I18n.notice, I18n.user.login

