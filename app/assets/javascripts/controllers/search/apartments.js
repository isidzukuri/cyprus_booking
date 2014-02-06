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
		else{
			window.hide_loader()
			$("#map_desults").remove()
			$("#main_map").append(resp.html)
			$.publish("map_width_resize")
			$.publish("show_hotels_on_map",[resp.data])
		}
	}
});