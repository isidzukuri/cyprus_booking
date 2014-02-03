$.Controller("Popup",{
	init:function(){

	},
	click:function(ev){
		var el = $(ev.target)
		if(el.attr("id")=="shadow"){
			ev.preventDefault();
			window.close_popup();
		}
	},
	".close -> click":function(ev){
		ev.preventDefault();
		window.close_popup();
	}

});