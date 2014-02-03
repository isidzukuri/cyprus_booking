$.Controller("Restore","FormController",{
	init:function(){
		this.form = this.element.find("form");
		this.super_call("init")
	},
	".close -> click":function(ev){
		ev.preventDefault();
		window.show_login_form();
	}
});