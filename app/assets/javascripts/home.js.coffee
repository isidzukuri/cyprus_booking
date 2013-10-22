$(window).load ->
  if($(".content").size() > 0 )
    $(".content").mCustomScrollbar advanced:
      updateOnContentResize: true
    $(".content").mCustomScrollbar("scrollTo","top")
  if /map/.test(window.location.hash)
    $(".mCSB_container").css("position","static")
  

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
  width = $(".currencies_block.cur ul").size() * 75
  $(".currencies_block.cur").width(width)

  $(document).click (ev) ->
    if $(ev.target).parents(".header_right").size() < 1
      $(".currencies_block").hide() if $(".currencies_block").is(":visible")


  $(".currency").click (ev) ->
    ev.preventDefault()
    data = "currency=" + $(ev.target).text()
    url  = $(ev.target).attr("href")
    $.ajax
      url: url 
      data: data
      type:"post"
      dataType:"json"
      success:(resp)->
        window.location.reload()

  $(".header_right a.cur,.header_right a.lang").click (ev) ->
    ev.preventDefault()
    $(".currencies_block").hide()
    
    block = if  $(ev.target).hasClass("lang") then $(".currencies_block.langs") else $(".currencies_block.cur") 
    left =   - (block.width() / 4) + 40
    block.css "left",left  
    block.find(".rectangle").css("left", (-left + 96)) unless  $(ev.target).hasClass("lang")
    $(".header_right ul:eq(0)").after block

    block.show()
