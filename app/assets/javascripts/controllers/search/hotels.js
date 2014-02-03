//= require ./form
$.Controller("HotelsSearchForm","SearchForm",{
	map_search:false,
	init:function(){
		this.super_call("init");
		this.element.find(".rooms_data.ft select").each(function(){$(this).selectbox("detach")})
		this.room = this.element.find(".rooms_data.ft .one_room").clone();
		this.labl = this.element.find(".rooms_data.ft label:eq(0)").clone();
		this.change_rooms_count(1);
		this.init_autocomplete(this.element.find(".city_name"));
	},

	".rooms_count select -> change":function(ev){
		var val =$(ev.target).val()
		this.change_rooms_count(Number(val))
	},
	".chd select -> change":function(ev){
		var el = $(ev.target);
		var idx = $(".one_room select").index(el)
		var next = el.parents(".chd").next(".chd_age");
			if(Number(el.val()) > 0){
				next.show()
			}
			else{
				next.hide()
			}
	},
	".one_room .sbOptions a ->click":function(ev){
		console.log(ev)
	},
	change_rooms_count:function(count){
		count > 1 ? this.element.find(".advaced_from").show() : this.element.find(".advaced_from").hide();
		this.element.find(".rooms_data").empty()
		var i = 1;
		while(i<=count){
			var block = this.room.clone();
			var lbl   = this.labl.clone();
			var sel   = block.find("select");
			sel.each(function(){
				var name = $(this).attr("name");
				if(typeof(name) != "undefined"){
					$(this).attr("name",name.replace("0",(i-1)))
				}
				$(this).selectbox({})
			})
			lbl.text(lbl.text().split(" ")[0] + " " + i)
			if(count == 1 || i == 1){
				this.element.find(".rooms_data.ft").append(lbl)
				this.element.find(".rooms_data.ft").append(block)
			}
			else{
				block.prepend(lbl)
				this.element.find(".rooms_data.fr").append(block)

			}

			i++;
		}
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