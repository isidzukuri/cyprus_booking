//= require ./form
$.Controller("Cabinet","FormController",{
	init:function(){
		this.form = this.element;
		this.super_call("init")
	},
	".pay_btn a -> click":function(ev){
	    ev.preventDefault()
	    if(this.form.valid())
	      this.form.submit()
	}
});