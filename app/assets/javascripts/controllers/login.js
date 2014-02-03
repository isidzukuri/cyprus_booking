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

});