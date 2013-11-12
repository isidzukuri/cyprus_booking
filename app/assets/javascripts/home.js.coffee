set_article_height = ->
  window.article_height = $(window).height() - $("header").height() - $("footer").height()
  $("article").height(window.article_height + 50) ;

$(window).resize ->
  set_article_height();
  ap_form = $("#apartments")
  if(ap_form.size() > 0 )
    ap_form.css("max-height",window.article_height - 40);
    $('#apartments').mCustomScrollbar("destroy");
    $('#apartments').mCustomScrollbar();
    $("#apartments").mCustomScrollbar("scrollTo","top");
  if($("#apartments_view").size() > 0 )
    $("#apartments_view").mCustomScrollbar("destroy");
    $("#apartments_view").mCustomScrollbar advanced:
      updateOnContentResize: true
    $("#apartments_view").css("left",$(window).width() - 480)
  if($('#map_apartments').length)
    $('#map_apartments').height($(window).height() - $("header").height() - $("footer").height() + 50)
    initialize();
  



$(window).load ->
  set_article_height()
  if($("#apartments").size() > 0 )
    $("#apartments").css("max-height",window.article_height - 40);
    $("#apartments").mCustomScrollbar advanced:
      updateOnContentResize: true
    $("#apartments").mCustomScrollbar("scrollTo","top")
  #if($("#apartments_view").size() > 0 )
   # $("#apartments_view").mCustomScrollbar advanced:
    #  updateOnContentResize: true
    #$("#apartments_view").mCustomScrollbar("scrollTo","top")


  if /map/.test(window.location.hash)
    $(".mCSB_container").css("position","static")
  #if($(".bookings_list").size() > 0 )
    #$(".bookings_list").mCustomScrollbar advanced:
     # updateOnContentResize: true,
      #updateOnBrowserResize:true 
  

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
    if $(ev.target).parents("#header_user_menu").size() < 1
      $("#header_user_menu").stop().animate top: -400 , 300, -> $(this).toggleClass "shown" if $("#header_user_menu").is(":visible")

  $(".currency").click (ev) ->
    ev.preventDefault()
    data = "currency=" + $(ev.target).text()
    url  = $(ev.target).parent().attr("href")
    console.log(url)
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
    $(".header_right ul:eq(0)").after block

    block.show()
