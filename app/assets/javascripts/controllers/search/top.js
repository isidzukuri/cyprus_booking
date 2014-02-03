//= require ./hotels
//= require ./apartments
$.Controller("TopSearchForm",{
	init:function(){
		this.forms = this.element.find("form");
		this.setup_controllers();
	},
	setup_controllers:function(){
		var forms = this.element.find("form");
		$(this.forms[0]).attachApartSearchForm();;
		$(this.forms[1]).attachHotelsSearchForm()
	},
	".search_type -> change":function(ev){
		var idx   = $(ev.target).val();
		this.forms.hide();
		this.forms.eq(idx).show();
	}
});