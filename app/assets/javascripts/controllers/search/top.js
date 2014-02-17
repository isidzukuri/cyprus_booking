//= require ./hotels
//= require ./apartments
$.Controller("TopSearchForm",{
	map_city_img:"/assets/icons/city.png",

	init:function(){
		this.forms = this.element.find("form");
		this.setup_controllers();
		$("#new_cars_search .date_input").datepicker({ 
	      dateFormat: "dd.mm.yy",
	      minDate: 0,
	  	  numberOfMonths: 2, 
	  	  dayNamesMin: I18n.days_short,
	  	  monthNames: I18n.months,
	  	  firstDay: 1,
	      onSelect: function(selected) {
	          var idx = ($(".date_input").index($(this)) + 1);
	          if( $(".date_input").size() >= idx){
	            var next_dp = $(".date_input:eq(" + idx + ")")
	            next_dp.datepicker("option","minDate", selected)
	            $(this).change()
	          }
	      },
		  beforeShow: function() {
		      $('#ui-datepicker-div').addClass("main_datepicker");
	   	  }
	    });
	},
	setup_controllers:function(){
		var forms = this.element.find("form");
		this.apart_ctrl = $(this.forms[0]).attachApartSearchForm().controller();
		this.hotels_ctrl= $(this.forms[1]).attachHotelsSearchForm().controller();
		this.cars_ctrl  = $(this.forms[2]).attachCarsSearchForm().controller();
		this.main_ctrl = $(".page").controller()
	},
	".search_type -> change":function(ev){
		var idx   = $(ev.target).val();
		this.forms.hide();
		this.forms.eq(idx).show();
		G_map.clearMarkers()
		$.publish("change_map_markers",[idx])
	},
	_marker:function(point,name,idx,id){
		var marker  = new google.maps.Marker({
		    position: point,
		    icon: this.parent.map_city_img,
		    title: name,
		    id:id

		});
		google.maps.event.addListener(marker, 'click', function(){
			$.publish("get_items",[idx,marker.id])
		});
		return marker
	},
	hotel_marker:function(data){
		$.publish("show_hotels_on_map",[data]);
	},
	cars_marker:function(data){
		window.location.href = data
		//$.publish("show_cars_on_map",[data]);
	},
	aparts_marker:function(data){
		$.publish("show_hotels_on_map",[data]);
	}
},
{
	"change_map_markers":function(idx){
		var markers = ["apart_cities","hotel_cities","cars_cities"];
		markers = locations[markers[idx]];
		//G_map.clearMarkers()
		for(i in markers){
			mar = markers[i];
			point = new google.maps.LatLng(Number(mar.lat),Number(mar.lng));
			G_map.addMarker(this._marker(point,mar.name,idx,mar.id))
		}
		

	},
	"get_items":function(idx,id){
		var self = this
		$.ajax({
			url:["/aparts/get_map_items","/hotels/get_map_items","/cars/get_map_items"][idx],
			dataType:"json",
			data:{id:id},
            beforeSend:function(){
            	window.show_loader($("form:first").data("search-text"));
            },
			success:function(resp){
				window.hide_loader()
				if(resp.success){
					G_map.clearMarkers()
					self[["aparts_marker","hotel_marker","cars_marker"][idx]](resp.data)
				}
				else{
					alert("Nothing found in this city")
				}
				
			},
			error:function(resp){
				alert("Error")
			}

		})
	}
});