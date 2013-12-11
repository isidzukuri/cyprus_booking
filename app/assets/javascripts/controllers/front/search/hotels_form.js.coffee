$.Controller "HotelsSearchFormController", "FormController",

  init: ->
    @setup_validation()
    @super_call("init")
    @element.find(".icon_date input").datepicker
      dateFormat: "dd.mm.yy"
      minDate: 0
      onSelect: (selected) ->
        idx = ($(".icon_date input").index($(this)) + 1)
        if $(".icon_date input").size() >= idx
          next_dp = $(".icon_date input:eq(" + idx + ")")
          next_dp.datepicker "option", "minDate", selected
          next_dp.datepicker "setDate", selected
    @advanced = @element.find(".advanced")   
    @init_autocomplete(@element.find("#hotels_search_city"))  
    
  setup_validation: ->
    @element.validate
      highlight: (el, e_cls) -> $(el).parent().addClass(e_cls)
      unhighlight: (el, e_cls) -> $(el).parent().removeClass(e_cls)
      errorPlacement: ->
      onkeyup: false
      onfocusout: false
      focusCleanup: true
      focusInvalid: false

  init_autocomplete: (el) ->
    el.autocomplete
      create: (a,b) -> 
        $($(this).data("autocomplete").bindings[1]).addClass("myclass")
      source: (req,add) ->
        req.term = req.term
        $.ajax
          url: '/hotels/complete' ,
          type: 'get'
          data: 'term='+req.term
          success: (response) ->
            add response
      open: (event, ui) ->
        inp = $(event.target)
        if $(".ui-menu-item:visible").length == 1
          $($(this).data('autocomplete').menu.active).find('a:visible').trigger('click');

      search: (event, ui) ->
        $(event.target).siblings('input[type=hidden]').val('')
      minLength: 3,
      selectFirst: true,
      autoFocus: true,
      select: (event, ui) =>
        input = $(event.target)
        input.siblings('input[type=hidden]').val(ui.item.code).change()
        input.val(ui.item.value)
        input.change()
        return false
    .each ->
      $(this).data("autocomplete")._renderItem = (ul, item) ->
 
        $("<li></li>")
          .data("item.autocomplete", item)
          .append("<a>#{item.value}</a>")
          .appendTo(ul)
          
  ".search_btn -> click":(ev) ->
    ev.preventDefault()
    if @element.valid() and Number(@element.find("#hotels_search_rooms_count").val()) > 0 and Number(@element.find("#hotels_search_rooms_attributes_0_adults").val()) > 0
      @search() 

  search: -> 
    window.LatLngList = []
    data = @element.serialize()
    self = @
    $.ajax
      url:"/hotels"
      type: "post"
      data: data
      beforeSend: ->
        show_loader I18n.hotels.search
      dataType: "json"
      success: (resp) ->
        if resp.success
          G_map.clearMarkers()
          if($("#list_view").size() > 0 )
            $("#map_apartments").animate width:"+=480px" , 300, ->
          $("#list_view").remove()
          $(".map").append(resp.html)
          w = $(window).width() 
          $("#list_view").css("left",w)
          $("#list_view").css("height",window.article_height)
          $("#list_view").animate left:"-=490px" , 300, ->
          $("#map_apartments").animate width:"-=480px" , 300, ->
            initialize()
            for m in resp.data
              self.add_marker(m)
            $(".search.active").click()

          if($("#list_view").size() > 0 )
            $("#list_view").mCustomScrollbar advanced:
              updateOnContentResize: true
          hide_loader()
        else
          show_notice(I18n.notice,resp.text)



  add_marker: (data) ->
    self = @
    Latlng = new google.maps.LatLng(Number(data.lat),Number(data.lng))
    window.LatLngList.push Latlng
    marker = new google.maps.Marker
      position: Latlng
      icon: '/assets/ic_map.png'
      map: G_map
    G_map.addMarker marker
    
    google.maps.event.addListener marker, "mouseover", ->
      marker.set "icon", '/assets/ic_map_hover.png'
      window.balloon.setContent data.name
      window.balloon.open G_map , marker
    google.maps.event.addListener marker, "mouseout", ->
      marker.set "icon", '/assets/ic_map.png'

    bounds = new google.maps.LatLngBounds()
    for i of window.LatLngList
      bounds.extend window.LatLngList[i]
      G_map.fitBounds bounds



  "#hotels_search_rooms_count -> change": (ev) ->
    count = Number($(ev.target).val())
    if count is 0
      @remove_advanced()
    else
      @load_advanced(count)
      @advanced.show()
   
  "input[type=text] -> change": (ev) ->
    inp = $(ev.target)
    if inp.hasClass('datepicker')
      pickers = @element.find('.datepicker')
      for dp in pickers
        if pickers.index($(dp)) > pickers.index(inp)
          $(dp).datepicker('option', 'minDate', inp.val())
    invalid = @element.find("input[type=text]:not(:valid):not(:disabled)").first()
    if invalid.length
      setTimeout ->
        invalid.focus()
      , 50
    else
      inputs     = @element.find('input[type=text]')
      next_valid = @element.find("input[type=text]:eq(#{inputs.index(inp) + 1})")
      if next_valid.length
        setTimeout ->
          next_valid.focus()
          next_valid.select() unless next_valid.is('.datepicker')
        , 50
    if @element.parent().hasClass('hotel_cal_page')
      @super_call("input[type=text] -> change", [ev])
    

        
  remove_advanced: ->
    sel = @element.find('#hotels_search_rooms_count')
    sel.val 1
    $.jNice.SelectUpdate sel
    @advanced.find('.form_list').remove()
    @advanced.hide()
    
  "ajax:success": (ev, data) ->
    console.log "finished"
    
  load_advanced: (count) ->
    self = @
    $.ajax
      url: "/hotels/get_advanced_form"
      data: "count="+count
      dataType: "json"
      #async: false
      success: (resp) ->
        unless resp.success
          self.remove_advanced()
          return
        self.advanced.find('.form_list').remove()
        self.advanced.find("ul:eq(0)").append(resp.html).jNice()
            