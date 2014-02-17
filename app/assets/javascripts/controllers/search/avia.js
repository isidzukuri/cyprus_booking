//= require ./form
$.Controller("AviaSearchForm","SearchForm",{
	init:function(){
		console.log("ss")
		this.super_call("init");
		this.init_autocomplete(this.element.find(".city_name"))
	},
	"#avia_search_same_place -> change":function(ev){
		if($(ev.target).is(":checked")){
			this.element.find("#avia_search_return_date").attr("disabled","disabled").addClass("disabled")
		}
		else{
			this.element.find("#avia_search_return_date").removeAttr("disabled").removeClass("disabled")
		}
		
	},
	success_call_back:function(resp){
		if(!resp.map_search)
			window.location.href = resp.url
		
	}
})