
$ ->

  $("*[data-auto-controller]").each ->
    plg = undefined
    plg.call $(this)  if plg = $(this)["attach" + $(this).data("auto-controller")]

