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
    $("#apartments").animate left: t + "=480px" , 300, ->