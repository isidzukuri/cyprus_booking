$.Controller("Registr","FormController",{
	init:function(){
		this.form = this.element.find("form");
		this.super_call("init")
	},
	".bottom -> click":function(ev){
	    ev.preventDefault()
	    if(this.form.valid())
	      this.submit_from()
	},
    "input#user_phone -> keyup":function(ev){
  	  el = $(ev.target);
  	  if( el.val().length == el.attr('maxlength') && el.attr('maxlength') != 10 ){
  		el.next().focus();
  	  }
    },
    success_call_back:function(resp){
    	window.close_popup();
    	var login_link = $(".menu a.login:first")
    	login_link.attr("href","/" + window.current_lang + "/cabinet")
    	login_link.html("")
    	login_link.removeClass("login")
    	login_link.append(resp.user.name)
    	login_link.append($("<img src=" + resp.user.avatar + " />"))
    },
    failure_call_back:function(resp){
    	this.show_error(resp.error)
    },
    setup_validation: function() {
      this.validator = this.form.validate({
        ignore: "",
        highlight: function(el, e_cls) {
          $(el).addClass(e_cls);
        },
        unhighlight: function(el, e_cls) {
          $(el).removeClass(e_cls);
        },
        errorPlacement: function(err,el) {
            
        },
        rules: {
         	password: {
                         required: true,
                         minlength: 5
         	},
         	password_confirm: {
                         required: true,
                         minlength: 5,
                         equalTo: "#user_password"
         	}
        },
        onkeyup: false,
        onfocusout: false,
        focusCleanup: true,
        focusInvalid: false,
        minlength:3
      });
    },
});


