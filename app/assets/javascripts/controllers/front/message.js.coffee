$.Controller "Message",
  init: ->
    @setup_validation(@element.find("form"))

  ".pay -> click": (ev) ->
    if !$(ev.target).hasClass("answer_it") && !$(ev.target).hasClass("delete_it")
      ev.preventDefault();
      if @element.find("form").valid()
        @do_book()
  ".delete_it -> click": (ev) ->
    ev.preventDefault();
    id = $(ev.target).parents(".buttons").data("id")
    action = $(ev.target).parents(".buttons").data("action")
    @delete_it(action,id)
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
  do_book: ->
    form = @element.find("form")
    $.ajax
      url: form.attr("action")
      data: form.serialize()
      type: "post"
      beforeSend: ->
        show_loader I18n.messages.send
      success: (resp) ->
        if resp.success
          hide_loader()
          show_notice I18n.success, I18n.messages.success
          window.location.href = resp.url
        else
          show_notice I18n.error, resp.msg
      error: ->
        show_notice I18n.error, I18n.server_error
  delete_it: (action,id) ->
    $.ajax
      url: "/cabinet/messages/" + action + "/" + id
      type: "get"
      beforeSend: ->
        show_loader I18n.messages.delete_it
      success: (resp) ->
        if resp.success
          hide_loader()
          show_notice I18n.success, I18n.messages.deleted
          window.location.reload()
        else
          show_notice I18n.error, resp.msg
      error: ->
        show_notice I18n.error, I18n.server_error