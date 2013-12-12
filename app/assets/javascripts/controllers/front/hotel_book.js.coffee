#= require ../form
$.Controller "HotelBooking", "FormController",
  init: ->
    @booking_form = @element.find("form")
    @setup_validation(@booking_form)
    @setup_mask()
    if @element.find(".b_data_pay").size() > 0
      @element.css("margin-top",0)
      @element.css("padding-bottom",0)
  setup_validation: (el) ->
    el.validate(
      ignore: ""
      highlight: (el, e_cls) ->
        $(el).addClass e_cls

      unhighlight: (el, e_cls) ->
        $(el).removeClass e_cls

      errorPlacement: (err, el) ->

      onkeyup: false
      onfocusout: false
      focusCleanup: true
      focusInvalid: true
      minlength: 6
    )
  ".pay -> click": (ev) ->
    ev.preventDefault()
    if @booking_form.valid()
      if $(ev.target).hasClass("to_book")
        @do_book()
      else if $(ev.target).hasClass("to_cancel")
        @do_cancel()
      else
        @booking_form.submit()
  setup_mask: -> 
    $("#hotels_booking_card_card_number").mask  "9999 9999 9999 9999", 
      placeholder: " ",
      completed: ->
        $("#hotels_booking_card_exp_date").focus()
    $("#hotels_booking_card_exp_date").mask "99/99", 
      placeholder: " "
      completed: ->
        $("#hotels_booking_card_cvv").focus()
    $("#hotels_booking_card_cvv").mask "999", 
      placeholder: " "
      completed: ->
        $("#hotels_booking_card_card_holder").focus()
  do_book: ->
    form = @booking_form
    $.ajax
      url: form.attr("action")
      data: form.serialize()
      beforeSend: ->
        show_loader I18n.hotels.do_book
      success: (resp) ->
        if resp.success
          hide_loader()
          show_notice I18n.success, I18n.hotels.success
        else
          show_notice I18n.error, resp.msg
      error: ->
        show_notice I18n.error, I18n.server_error
  do_cancel: ->
    form = @booking_form
    $.ajax
      url: form.attr("action")
      data: form.serialize()
      beforeSend: ->
        show_loader I18n.hotels.do_cancel
      success: (resp) ->
        if resp.success
          window.location.reload()
        else
          show_notice I18n.error, resp.msg
      error: ->
        show_notice I18n.error, I18n.server_error



