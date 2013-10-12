#= require ../form
$.Controller "ApartmentsController", "FormController",
  init: ->
    @super_call("init")

  success_call_back: ->
    window.location.reload()

  failure_call_back: (resp) ->
    alert resp.error
  ".adv_but -> click":(ev) ->
    ev.preventDefault()
    if $(ev.target).hasClass("active") then $(ev.target).removeClass("active") else $(ev.target).addClass("active")
    this.element.find(".advanced").slideToggle()

