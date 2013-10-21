$.Controller "ApartmentTabsController",
  init: ->
    @setup_active_tab()  
  "a -> click": (ev) ->
    @change_tab($(ev.target))
  setup_active_tab: ->
    @element.find("a").removeClass("act")
    @element.find("a[href=" + window.location.hash + "]").addClass("act")	
  change_tab:(tab) ->
    tab.siblings().removeClass("act")
    tab.addClass("act")