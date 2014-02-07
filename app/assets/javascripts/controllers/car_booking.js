$.Controller("CarBooking",{
	bubbling: false,
	init:function(){
		this.setup_mask();
		this.setup_validation()
		var el  = this.element.find(".fanc a")
		el.fancybox({
		  type: 'ajax',
		  href: el.attr('href'),
		  maxHeight: 600,
		  minWidth: 800,
		  padding: 0,
		  autoDimensions: false,
		  maxWidth: 800
		});
	},
	".to_pay a -> click":function(ev){
		ev.preventDefault()
		if($(ev.target).hasClass("login")){
			window.show_login_form()
		}
		else{
		if(this.element.valid())
				if($(ev.target).hasClass("send_request")){
					this.send_request(this.element)
				}
				else{
					this.element.submit()	
				}	
		}

	},
    setup_validation: function() {
      this.validator = this.element.validate({
        ignore: "",
        highlight: function(el, e_cls) {
          $(el).addClass(e_cls);
        },
        unhighlight: function(el, e_cls) {
          $(el).removeClass(e_cls);
        },
        errorPlacement: function(err,el) {
            
        },
        onkeyup: false,
        onfocusout: false,
        focusCleanup: true,
        focusInvalid: false,
        minlength:3
      });
    },
    "input[type=text] -> change": function(ev) {
	    if(!this.parent.bubbling) this.next_unfilled_input()
    },
    setup_mask:function(){
	    this.element.find("#cars_pay_expiration_date").mask("99/99",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#cars_pay_n_0").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#cars_pay_n_1").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#cars_pay_n_2").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#cars_pay_n_3").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#cars_pay_ccv").mask("999",{placeholder:" ", completed:this.next_unfilled_input})
    },    
	  next_unfilled_input: function(){
	  	var unfilled = [], unfl;
	  	this.parent.bubbling = true;
	  	this.element.find("input[type=text]").each(function(){
	  		if( $(this).val() == "" || $(this).val().replace(/\s+/, "").replace(/\s+/, "").replace("/", "") == "" ) {
	  			unfilled.push($(this))
	  		}
	  	});

	  	if(unfilled.length > 0) {
	  		unfl = unfilled[0];
	  		unfilled = [];
	  		this.parent.bubbling = false;
	  		unfl.focus();
	  	}
	  },
  send_request:function(form){
  	$.ajax({
  		url:form.attr("action"),
  		data:form.serialize(),
  		type:"post",
		beforeSend:function(){
          	window.show_loader(window.I18n.cars_pay);
		},
  		dataType:"json",
  		success:function(resp){
  			if(resp.success){
  				window.show_message(window.I18n.cars_pay_success);
  				window.location.href = form.data("url") + resp.id
  			}
  			else{
  				window.show_message(resp.msg);
  			}
  		},
        error:function(){
			window.hide_loader();
			window.show_message(I18n.server_error);
        },

  	})
  },
  ".only_chars -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^а-яА-ЯA-zA-ZіЇіІЄє]/, ""))
  },
  ".only_chars_with_space -> keyup":function(ev){
    var el  = $(ev.target)
    var val = el.val().replace(/[^а-яА-Яa-zA-ZіЇіІЄє\s]/, "").split(" ")
    val.length > 2 ? val.pop() : false;
    el.val(val.join(" "))
  },
  ".only_latin -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^a-zA-Z]/, ""))
  },
  ".only_latin_with_space -> keyup":function(ev){
    var el  = $(ev.target)
    var val = el.val().replace(/[^a-zA-Z\s]/, "").split(" ")
    val.length > 2 ? val.pop() : false;
    el.val(val.join(" "))
  },
  ".only_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9]/, ""))
  },


})