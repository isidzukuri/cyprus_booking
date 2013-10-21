#= require ../form
$.Controller "ApartmentsController", "FormController",
  init: ->
    @super_call("init")
    @element.find(".icon_date input").datepicker()
    @init_autocomplete()

      


  success_call_back: ->
    window.location.reload()

  failure_call_back: (resp) ->
    alert resp.error

  search: ->
    @LatLngList = [] 
    data = @element.serialize()
    self = @
    $.ajax
      url:"/apartments"
      type: "post"
      data: data
      dataType: "json"
      success: (resp) ->
        G_map.clearMarkers()
        for m in resp
          self.add_marker(m)

        


  ".adv_but -> click":(ev) ->
    ev.preventDefault()
    if $(ev.target).hasClass("active") then $(ev.target).removeClass("active") else $(ev.target).addClass("active")
    @element.find(".advanced").slideToggle()

  ".search_btn -> click":(ev) ->
    ev.preventDefault()
    @search() if @element.valid()
  
  add_marker: (data) ->
    self = @
    Latlng = new google.maps.LatLng(Number(data.latitude),Number(data.longitude))
    @LatLngList.push Latlng
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
    for i of @LatLngList
      bounds.extend @LatLngList[i]
      G_map.fitBounds bounds

  show_apart: (data) ->
    self = @
    $.ajax
      url:"/apartments/show_index"
      type: "post"
      data: "id=" + data.id
      dataType: "json"
      success: (resp) ->
        $("#apartments_view").remove()
        $(".map").append(resp.html)
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
          $($(this).data('autocomplete').menu.active).find('a:visible').trigger('click');
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

  