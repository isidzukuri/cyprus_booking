
$ ->
  $.validator.addMethod "valid_card_number", ((value, element) ->
    console.log("wefew")
    val = value.replace(/[^\d.]/g, "")
    val.length is 4
  ), "Please enter a valid card number."
  $.validator.addMethod "valid_expiry_date", ((value, element) ->
    return false  if value.length is 0
    return false  unless value.length is 2
    return false  unless $(element).val().length is 2
    if $(element).attr("id") is "payment_card_valid_y"
      return false  if value.length is 0
      return false  unless value.length is 2
      m = $("input[name=payment_card_valid_m]:visible").val()
      y = $("input[name=payment_card_valid_y]:visible").val()
      return false  if m.length isnt 2 or y.length isnt 2
      expire_date = new Date(parseFloat("20" + y), parseFloat(m) - 1, 1, 0, 0, 0)
      expire_date > new Date
    else
      true
  ), "Please enter a valid expiration date."
  $.validator.addMethod "valid_cvv2_number", ((value, element) ->
    $.trim(value).length is 3
  ), "Please enter a valid card number."


  $("*[data-auto-controller]").each ->
    plg = undefined
    plg.call $(this)  if plg = $(this)["attach" + $(this).data("auto-controller")]

  $(".cabinet_button").click (ev) ->
    ev.preventDefault()
    unless $(".my_menu .subs").hasClass("disabled")
      $(".my_menu .subs").slideToggle()
    else
      $(".my_menu form:eq(0)").show("slow")


  $("html").click (ev) ->
    if $(ev.target).closest(".registration").length is 0 && !$(ev.target).hasClass("cabinet_button")
      $(".my_menu form").hide("slow")

