//= require ./form
$.Controller("Login","FormController",{
	init:function(){
		this.form = this.element.find("form");
		this.super_call("init")
	},
	".forgot_pass -> click":function(ev){
		ev.preventDefault();
		window.close_popup();
		window.show_restor_pass();

	},
	".bottom -> click":function(ev){
	    ev.preventDefault()
	    if(this.form.valid())
	      this.submit_from()
	},
    success_call_back:function(resp){
    	window.close_popup();
    	var login_link = $(".menu a.login")
    	$(".login").removeClass("login")
    	login_link.attr("href","/" + window.current_lang + "/cabinet")
    	login_link.html("")
    	login_link.append(resp.user.name)
    	login_link.append($("<img src=" + resp.user.avatar + " />"))
    },
    failure_call_back:function(resp){
    	this.show_error(resp.error)
    },
});