$.Controller "PaymentFormController", "FormController",
  init: ->
    @super_call("init")
  setup_validation: ->
  	i = 1
  	$("#payment_card_valid_m").mask "99"
  	$("#payment_card_valid_y").mask "99"
  	$("#payment_card_cvv").mask "999"
  	$("#payment_card_number").mask "9999"
  	while i < 5
  	  $("#payment_card_number" + i).mask "9999"
  	  i++
    @super_call("setup_validation")
  submit: ->
  	console.log("wefew")
  setup_submit: ->
    @element.ajaxformbar
      success:(resp)->
        if resp.success
          window.location.href = resp.url
        else
          alert resp.error
    form = @element
    $(".submit").click (ev) ->
      ev.preventDefault()
      if $("#eula_accept").is(":checked")
        form.data("ajaxformbar").el.submit()
        form.submit()
