//= require ./hotels
//= require ./apartments
$.Controller("TopSearchForm",{
	map_city_img:"/assets/icons/city.png",
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
		
		$.ajax({
			url:["/apartments/get_map_items","/hotels/get_map_items","/cars/get_map_items"][idx],
			dataType:"json",
			data:{id:id},
			success:function(reps){
				console.log(reps)
			},
			error:function(resp){
				console.log(resp)
				alert("Error")
			}

		})
	}
});