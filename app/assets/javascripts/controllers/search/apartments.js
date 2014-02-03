//= require ./form
$.Controller("ApartSearchForm","SearchForm",{
	map_search:false,
	init:function(){
		this.super_call("init");
		this.init_autocomplete(this.element.find(".city_name"))
	},
	success_call_back:function(resp){
		if(!resp.map_search)
			window.location.href = resp.url
		else
			console.log("efwe")
	}
});