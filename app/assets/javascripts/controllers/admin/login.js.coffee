#= require ../form
$.Controller "AdminLoginController", "FormController",
  init: ->
    @super_call("init")

  success_call_back: ->
    window.location.reload()

  failure_call_back: (resp) ->
    alert resp.error
  ".register -> click":(ev)->
    ev.preventDefault()
    $("#login_form").hide()
    $("#login_form.registered").show()

  ".forgot -> click":(ev) ->
    ev.preventDefault()
    $("#login_form").hide()
    $("#login_form.forgot").show()

$.Controller "LoginController", "FormController",
  init: ->
    @super_call("init")

  success_call_back: ->
    $(".subs").removeClass("disabled")
    @element.remove()

  failure_call_back: (resp) ->
    alert resp.error
  ".forgot -> click": (ev) ->
    ev.preventDefault()
    @element.hide()
    @element.next().show()

    

$.Controller "ForgotController", "FormController",
  init: ->
    @super_call("init")

  success_call_back:(resp) ->
    alert resp.msg
    @element.hide()

  failure_call_back: (resp) ->
    alert resp.error

  ".register -> click": (ev) ->
    ev.preventDefault()
    $("#login_form.forgot").hide()
    $("#login_form.log").show()

