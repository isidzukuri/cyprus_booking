#= require ../../form
$.Controller "ApartmentsController", "FormController",
  init: ->
    $("html").css("min-height","742px")
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
    @init_autocomplete()

      


  success_call_back: ->
    window.location.reload()

  failure_call_back: (resp) ->
    alert resp.error

  search: ->
    $("#apartments_view").remove()
    window.LatLngList = [] 
    data = @element.serialize()
    self = @
    show_loader I18n.aparts.search
    $.ajax
      url:"/apartments"
      type: "post"
      data: data
      beforeSend: ->
        show_loader I18n.aparts.search
      dataType: "json"
      success: (resp) ->
        if resp.success
          if resp.data.length > 0
            G_map.clearMarkers()
            if($("#list_view").size() > 0 )
              $("#map_apartments").animate width:"+=480px" , 300, ->

            $("#list_view").remove()
            $(".map").append(resp.html)
            w = $(window).width() 
            $("#list_view").css("left",w)
            $("#list_view").css("height",window.article_height)
            
            $("#list_view").animate left:"-=500px", 300, ->
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
            show_notice(I18n.notice,I18n.aparts_notice)
        else
          show_notice(I18n.error,I18n.aparts_error)

        


  ".adv_but -> click":(ev) ->
    ev.preventDefault()
    if $(ev.target).hasClass("active") then $(ev.target).removeClass("active") else $(ev.target).addClass("active")
    @element.find(".advanced").toggle()

  ".search_btn -> click":(ev) ->
    ev.preventDefault()
    @search() if @element.valid()
  
  add_marker: (data) ->
    self = @
    Latlng = new google.maps.LatLng(Number(data.latitude),Number(data.longitude))
    window.LatLngList.push Latlng
    marker = new google.maps.Marker
      position: Latlng
      icon: '/assets/ic_map.png'
      map: G_map
    G_map.addMarker marker
    google.maps.event.addListener marker, 'click', ->
      i = 0
      while i < G_map.markers.length
        G_map.markers[i].set "icon", '/assets/ic_map.png'
        i++
      marker.set "icon", '/assets/ic_map_hover.png'
      self.show_apart(data)
    $(".content_box").find(".text:eq(0)").text(data.price)
    $(".content_box").find(".text:eq(1)").text(data.rooms)
    $(".content_box").find(".text:eq(2)").text(data.rating)
    $(".content_box").find(".text:eq(3)").text(data.places)

    google.maps.event.addListener marker, "mouseover", ->
      window.balloon.setContent $(".content_box").show().html()
      window.balloon.open G_map , marker
      marker.set "icon", '/assets/ic_map_hover.png'

    google.maps.event.addListener marker, "mouseout", ->
      window.balloon.close()
      $(".content_box").hide()
      marker.set "icon", '/assets/ic_map.png'


    bounds = new google.maps.LatLngBounds()
    for i of window.LatLngList
      bounds.extend window.LatLngList[i]
      G_map.fitBounds bounds

  show_apart: (data) ->
    self = @
    $.ajax
      url:"/apartments/show_index"
      type: "get"
      data: "id=" + data.id
      dataType: "json"
      success: (resp) ->
        $("#apartments_view").remove();
        w = $(window).width() 
        $(".map").append(resp.html)
        $("#apartments_view").css("left",w)
        $("#apartments_view").animate left:"-=480px" , 300, ->
        if($("#apartments_view").size() > 0 )
          $("#apartments_view").mCustomScrollbar advanced:
            updateOnContentResize: true
        url = ""
        $(".rating").rating url ,
          curvalue: 3
  init_autocomplete: ->
    @element.find("#apartment_search_city").autocomplete
      source: '/apartments/complete',
      create: (a,b) -> 
        $($(this).data("autocomplete").bindings[1]).addClass("myclass")
      search: (event, ui) ->
        $(event.target).siblings('input[type=hidden]').val('')
        G_map.setCenter(Base_coords)
        G_map.setZoom(9)
      minLength: 2,
      open: ->
        if $(".ui-menu-item:visible").length == 1
          $(".ui-menu-item:visible").trigger('click');
      select: (event, ui) =>
        input      = $(event.target)
        code_input = input.siblings('input[type=hidden]')
        text       = ui.item.name_ru+"  "+ui.item.country
        input.val(text)
        code_input.val(ui.item.id)
        input.change()
        code_input.change()
        lat_lng = new google.maps.LatLng(ui.item.lat, ui.item.lng);
        G_map.setCenter(lat_lng)
        G_map.setZoom(13)
        return false
    .each ->
      $(this).data("autocomplete")._renderItem = (ul, item) ->
        $("<li></li>")
          .data("item.autocomplete", item)
          .append("<a><strong>#{item.name_ru}</strong>  #{item.country}</a>")
          .appendTo(ul)

  