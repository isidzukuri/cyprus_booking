set_article_height = ->
  window.article_height = $(window).height() - $("header").height() - $("footer").height()
  $("article").height(window.article_height + 50) ;
window.show_loader = (text) ->
  $(".bg_loader,#loader_text,#circularG").show();
  $("#loader_notice").hide();
  $("#loader_text p").text(text)
window.hide_loader = ->
  $(".bg_loader").hide();
window.show_notice = (header,text) ->
   $(".bg_loader,#loader_text,#circularG").hide();
   $("#loader_notice h2 span").text(header);
   $("#loader_notice p").text(text);
   $(".bg_loader,#loader_notice").show();


$(window).resize ->
  set_article_height();
  forms = ["apartments","hotels","list_view"]
  for i in forms
    ap_form = $("#" + i)
    if(ap_form.size() > 0 )
      sv = if i is "hotels" then "height" else "max-height"
      ap_form.css(sv,window.article_height - 40);
      $('#' + i ).mCustomScrollbar("destroy");
      $('#' + i ).mCustomScrollbar();
      $('#' + i ).mCustomScrollbar("scrollTo","top");
  if($("#apartments_view").size() > 0 )
    $("#apartments_view").mCustomScrollbar("destroy");
    $("#apartments_view").mCustomScrollbar advanced:
      updateOnContentResize: true
    $("#apartments_view").css("left",$(window).width() - 480)
  if($(".right_side").size() > 0 )
    $('.right_side').height($(window).height() - $("header").height() - $("footer").height() + 50)
    $(".right_side").css("left",$(window).width() - 500)
  if($('#map_apartments').length)
    $('#map_apartments').height($(window).height() - $("header").height() - $("footer").height() + 50)
    initialize();
  



$(window).load ->
  set_article_height()
  forms = ["apartments","hotels","apartments_view"]
  for i in forms
    if($("#" + i).size() > 0 )
      sv = if i is "hotels" then "height" else "max-height"
      $("#" + i).css(sv,window.article_height - 40);
      $("#" + i).mCustomScrollbar advanced:
        updateOnContentResize: true
      $("#" + i).mCustomScrollbar("scrollTo","top")



  if /map/.test(window.location.hash)
    $(".mCSB_container").css("position","static")

  

$ ->
  window.enadle_popups()
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
    $.ajax
      url: url 
      data: data
      dataType:"json"
      success:(resp)->
        window.location.reload()

  $(".header_right a.cur,.header_right a.lang").click (ev) ->
    ev.preventDefault()
    $(".currencies_block").hide()
    block = if  $(ev.target).hasClass("lang") then $(".currencies_block.langs") else $(".currencies_block.cur") 
    $(".header_right ul:eq(0)").after block
    block.show()
  $("#loader_notice a").click (ev) ->
    ev.preventDefault();
    hide_loader()
  $(".form-submit").live "click", (ev) ->
    if $(ev.target).parents("#list_view").hasClass("hotel")
      ev.preventDefault()
      $.ajax
        url: $(ev.target).parents("form").attr("action") 
        beforeSend: ->
          show_loader I18n.hotels.search_hotel
        data: $(ev.target).parents("form").serialize()
        dataType:"json"
        success:(resp)->
          if resp.success
            window.location.href = resp.url_
          else
            show_notice(I18n.error,resp.text)
          

window.show_info_popup = (where, text, at_top) ->
  popup = undefined
  top = undefined
  at_top = false  unless at_top?
  popup = $(".b_errors:eq(0)")
  popup.find("span").text text
  popup.css width: where.width()
  if at_top
    popup.addClass "b_errors_fields"
    top = where.offset().top - where.height() - popup.height()
  else
    popup.removeClass "b_errors_fields"
    top = where.offset().top + where.height() + 15
  popup.css
    top: top
    left: where.offset().left + (where.outerWidth() / 2) - (popup.outerWidth() / 2)

  popup.show()

window.hide_info_popup = ->
  $(".b_errors").hide()
  $(".errors_block").show()

window.enadle_popups = ->
  $("*[data-popup-info]").each (i, k) ->
    el = undefined
    el = $(this)
    el.focus (ev) ->
      window.show_info_popup el, el.data("popup-info"), true

    el.blur (ev) ->
      window.hide_info_popup()

