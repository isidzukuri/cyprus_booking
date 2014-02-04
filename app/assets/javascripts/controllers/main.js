$.Controller("Main",{
	map_width:0,
	map_image: "/assets/ic_map.png",
	map_image_hover:"/assets/ic_map_hover.png",
	init:function(){
		this.map  = this.element.find("#main_map")
		this.main = this.element.find("#main")
		this.setup_map_height();
		$.publish("set_lang_menu_position");
		$.publish("set_currency_menu_position");
	},
	".choose_buttons a , .search .list a -> click":function(ev){
		ev.preventDefault();
		var el = $(ev.target).parent();
		if(el.hasClass("active"))
			return;
		el.siblings().removeClass("active");
		el.addClass("active");
		action = el.parents(".action_div").data("action")
		this[action].call(undefined,$(ev.target).attr("href").replace("#",""))
		
	},
	".login -> click":function(ev){
		ev.preventDefault();
		window.show_login_form();
	},
	".lang -> click":function(ev){
		ev.preventDefault();
		this.element.find(".lang_block").show()
	},
	".currency -> click":function(ev){
		ev.preventDefault();
		this.element.find(".currency_block").show()
	},
	".currency_block a -> click":function(ev){
		// ev.preventDefault();
		// var currency = $.trim($(ev.target).text())
		// this.change_data("currency",{currency:currency});
	},
	".lang_block a -> click":function(ev){
		// ev.preventDefault();
		// var lang 	= $.trim($(ev.target).text())
		// this.change_data("lang",{lang:lang});
	},
	".res_item -> mouseover":function(ev){
		var el = $(ev.target).hasClass(".res_item") ? $(ev.target) : $(ev.target).parents(".res_item")
		this.markers[el.attr("id")].setIcon(this.parent.map_image_hover)
	},
	".res_item -> mouseout":function(ev){
		var el = $(ev.target).hasClass(".res_item") ? $(ev.target) : $(ev.target).parents(".res_item")
		this.markers[el.attr("id")].setIcon(this.parent.map_image)
	},
	change_data:function(type,args){
		var self = this;
		$.ajax({
			url:"/change_" + type,
			dataType:"json",
			data:args,
			beforeSend:function(){
				window.show_loader("some text");
			},
			success:function(resp){
				self["change_" + type + "_callback"](resp);
				//window.hide_loader();
			},
			error:function(){
				//window.hide_loader();
				//window.show_message("error");
			}
		});
	},
	change_lang_callback:function(resp){
		window.location.href = resp.url
	},
	change_currency_callback:function(resp){
		console.log("changed")
	},
	setup_map_height:function(){
		this.map.height(window.main_height() - this.element.find(".choose_buttons").height() - 30);
	},
	set_active_form:function(el){
		var el = this.element.find(".search_forms ." + el)
		el.siblings().hide()
		el.show()
	},
	set_active_faq:function(el){
		var el = this.element.find(".faq_list ." + el)
		el.siblings().hide()
		el.show()
	},
	set_active_tab:function(el){
		$.publish("remove_static");
		var self = this;
		if(el=="main"){
			this.main.hide();
			this.map.show()
			this.map.animate({'margin-left': "+=100%"},300,function(){
				self.initialize_map()
				self.set_width();
			});
			ApartSearchForm.map_search  = true
			HotelsSearchForm.map_search = true
		}
		else{
			ApartSearchForm.map_search  = false
			HotelsSearchForm.map_search = false
			this.map.animate({'margin-left': "-=100%"},300,function(){
				self.map.hide()
				self.main.show();
			})
		}
	},
	set_width:function(){
		this.parent.map_width = this.element.find("#g_map").width()
	},
	initialize_map:function(){
		if(typeof(google) == "undefined")
			return;
		Base_coords   = new google.maps.LatLng(35, 33);
		var mapCanvas = document.getElementById('g_map');
	    var mapOptions = {
	      center: Base_coords,
	      zoom: 9,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    }

	    this.bounds  = new google.maps.LatLngBounds();
	    this.markers = {}
	    if(typeof(G_map)!="undefined"){
	    	 G_map.clearMarkers();
	    }
	    G_map = new google.maps.Map(mapCanvas, mapOptions);
	    this.element.find("#map_desults").height($("#g_map").height() - $("#footer").height() - 10);
	},
	marker:function(data,prefix){
		var self = this
		var lat_lng = new google.maps.LatLng(Number(data.lat),Number(data.lng));
		var marker  = new google.maps.Marker({
		    position: lat_lng,
		    map: G_map,
		    icon: self.parent.map_image,
		    title: data.name,

		});
		google.maps.event.addListener(marker, 'mouseover', function(){
			$('#map_desults').scrollTo($("#" + prefix + data.id),{duration:200});
			marker.setIcon(self.parent.map_image_hover)
		});
		google.maps.event.addListener(marker, 'mouseout', function(){
			marker.setIcon(self.parent.map_image)
		});
		this.bounds.extend(lat_lng);
		this.markers[prefix + data.id] = marker
		return marker
	}
},
{
	"remove_static":function(){
		$("#map_desults").hide()
	},
	"set_lang_menu_position":function(){
		var left  = this.element.find(".lang").offset().left
		var block = this.element.find(".lang_block")
		var position = left - block.width() / 3 + 30
		block.offset({left:position})
	},
	"set_currency_menu_position":function(){
		var left  = this.element.find(".currency").offset().left
		var block = this.element.find(".currency_block")
		var position = left - block.width() / 3 + 40
		block.offset({left:position})
	},
	"map_width_resize":function(){
		var map = this.element.find("#g_map")
		map.width((this.parent.map_width - 580))
		this.initialize_map()
	},
	"show_hotels_on_map":function(data){
		for (var i = 0; i < data.length; i++) {
			G_map.addMarker(this.marker(data[i],"hotel_")) 
		};
		G_map.fitBounds(this.bounds)
	}
});
