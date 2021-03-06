$.Controller "ApartmentTabsController",
  init: ->
    @setup_active_tab()  
  "a -> click": (ev) ->
    @change_tab($(ev.target))
    $("html, body").animate({ scrollTop: 0 }, "slow");

  setup_active_tab: ->
    @element.find("a").removeClass("act")
    @element.find("a[href=" + window.location.hash + "]").addClass("act")	
    $(window.location.hash).show()
    @check_map(window.location.hash)


  change_tab:(tab) ->
    tab.siblings().removeClass("act")
    tab.addClass("act")
    $('.tab').hide()
    $(".tab" + tab.attr("href")).show()
    @check_map(tab.attr("href"))
    $("html,body").scrollTop(0)

  check_map: (_hash_) ->
    $("html,body").scrollTop(0)
    if /map|calendar|rewiew/.test(_hash_) then $(".photos").hide() else $(".photos").show()
    if /map/.test(_hash_)
      $(".mCSB_container").css("position","static")
      mapCanvas = document.getElementById("g_map")
      Latlng    = new google.maps.LatLng($("#map").data("lat"), $("#map").data("lng"))
      mapOptions =
        center: Latlng
        zoom: 14
        mapTypeId: google.maps.MapTypeId.ROADMAP
      G_map = new google.maps.Map(mapCanvas, mapOptions);
      marker = new google.maps.Marker
        position: Latlng
        icon: '/assets/ic_map.png'
        map: G_map
    else
      $(".mCSB_container").css("position","relative")
      $(".mCSB_container").css("top","0")
      