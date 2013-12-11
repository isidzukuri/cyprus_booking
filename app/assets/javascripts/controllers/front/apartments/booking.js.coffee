$.Controller "ApartBooking",
  init: ->
  	@travelers_block = @element.find(".guests")
  	@traveler        = @element.find(".guests .traveler").clone()
  	@traveler_form   = @element.find("#traveler")
  	@booking_form 	 = @element.find("#new_apartments_booking")
  	@travelers_block.find(".traveler").remove()
  	@setup_validation(@traveler_form)


  ".delete a -> click":(ev)->
  	ev.preventDefault()
  	$(ev.target).parents(".traveler").remove();
  "#traveler .add -> click":(ev) ->
  	ev.preventDefault()
  	if @traveler_form.valid()
      @fill_travelers()
  ".pay -> click": (ev) ->
  	ev.preventDefault()
  	if(@booking_form.find("input[type=hidden]").size() > 2)
  		@booking_form.submit()


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
  fill_travelers: ->
  	self = @
  	block = self.traveler.clone()
  	@traveler_form.find("input[type=text],input[type=email]").each ->
  	  el = $(this)
  	  block.find("." + el.attr("id").replace("tr_","")).text(el.val())
  	  block.find(".i_" + el.attr("id").replace("tr_","")).val(el.val())
  	self.travelers_block.append(block)
  	@traveler_form.find("input[type=text],input[type=email]").val("")
  	