#= require ../form
$.Controller "RegisterController", "FormController",
  init: ->
    @super_call("init")

  success_call_back: ->
    window.location.reload()

  failure_call_back: (resp) ->
    alert resp.error
  ".enter -> click":(ev)->
    ev.preventDefault()
    $(".registered").hide()
    $(".log").show()
  ".forgot -> click":(ev) ->
    ev.preventDefault()
    $(".registered").hide()
    $("#login_form.forgot").show()