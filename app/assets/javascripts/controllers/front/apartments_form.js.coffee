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
      window.balloon.setContent "ewefewfwfwe"
      window.balloon.open G_map , marker
    
    bounds = new google.maps.LatLngBounds()
    for i of @LatLngList
      bounds.extend @LatLngList[i]
      G_map.fitBounds bounds


  init_autocomplete: ->
    @element.find("#apartment_search_city").autocomplete
      source: '/apartments/complete',
      search: (event, ui) ->
        $(event.target).siblings('input[type=hidden]').val('')
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
        return false
    .each ->
      $(this).data("autocomplete")._renderItem = (ul, item) ->
        $("<li></li>")
          .data("item.autocomplete", item)
          .append("<a><strong>#{item.name_ru}</strong>  #{item.country}</a>")
          .appendTo(ul)

  