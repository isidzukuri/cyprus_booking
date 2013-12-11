$.Controller "MapController",
  init: ->
    @initialize()


  initialize: ->
    mapCanvas = document.getElementById("map_apartments")
    mapOptions =
      center: new google.maps.LatLng(35, 33)
      zoom: 9
      mapTypeId: google.maps.MapTypeId.ROADMAP

  ".line .search -> click": (ev) ->
    ev.preventDefault()
    el = @element.find("#" + window.type)
    if $(ev.target).hasClass("active") then $(ev.target).removeClass("active") else $(ev.target).addClass("active")
    t = if el.offset().left < 0 then "+" else "-" 
    el.animate left: t + "=480px" , 300, ->


  ".h_item -> mouseenter": (ev) ->
    el = if $(ev.target).hasClass("h_item") then $(ev.target) else $(ev.target).parents(".h_item")

    lat_lng = new google.maps.LatLng(Number(el.data('lat')),Number(el.data('lng')))
    #G_map.setCenter lat_lng
    #G_map.setZoom 12
  ".close.black -> click":(ev)->
    ev.preventDefault()
    $("#apartments_view").animate left:"+=480px" , 300, 
      ->
        $("#apartments_view").remove()

