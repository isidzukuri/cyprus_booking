


$ ->
  if typeof(google) isnt "undefined"
      window.balloon = new google.maps.InfoWindow
        'size': new google.maps.Size(430,205)
        'maxWidth':430
        'maxHeight':205
      google.maps.Map.prototype.markers = new Array()
      google.maps.Map.prototype.addMarker = (marker) ->
        this.markers[this.markers.length] = marker;
      google.maps.Map.prototype.getMarkers = ->
        return this.markers
      google.maps.Map.prototype.clearMarkers = ->
        if window.balloon
          window.balloon.close()  
        i = 0
        while i < this.markers.length
          this.markers[i].setMap(null)
          i++
        this.markers = [];


  $("*[data-auto-controller]").each ->
    plg = undefined
    plg.call $(this)  if plg = $(this)["attach" + $(this).data("auto-controller")]

  $(".header_right a").click (ev) ->
    ev.preventDefault()
    left = $(ev.target).offset().left
    console.log(left)
    block = $(ev.target).next()
    $(".header_right ul:eq(0)").after block
    block.show()
   # block.css "left" , left

    
#currencies_block