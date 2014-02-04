$.Controller("Restore","FormController",{
	init:function(){
		this.form = this.element.find("form");
		this.super_call("init")
	},
	".close -> click":function(ev){
		ev.preventDefault();
		window.show_login_form();
	},
	".bottom -> click":function(ev){
	    ev.preventDefault()
	    if(this.form.valid())
	      this.submit_from()
	},
    success_call_back:function(resp){
    	console.error("Redefine this method")
    },
    failure_call_back:function(resp){
    	this.show_error(resp.error)
    },
});