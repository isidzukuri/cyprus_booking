$(window).load(function(){
	if($('#map_apartments').length){
		$('#map_apartments').height($(window).height() - $('#header').height())
		initialize();
	}
	initialize_map()
});


function initialize() {
	var mapCanvas = document.getElementById('map_apartments');
    var mapOptions = {
      center: new google.maps.LatLng(35, 33),
      zoom: 9,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(mapCanvas, mapOptions);
}

var Gmap;
var marker;
var balloon;

function initialize_map(lat,lng){ 
	lat_inp = $('#house_latitude');
	lng_inp = $('#house_longitude');
	lat = lat_inp.val();
	lng = lng_inp.val();
	LAT = lat != '' && lat != 0 ? lat : Number(35);
	LNG = lng != '' && lng != 0 ? lng : Number(33);
	var center = new google.maps.LatLng(LAT,LNG);
	// balloon = new google.maps.InfoWindow({
	// 	size: new google.maps.Size(80,20),
	// 	content: "Не выбрана станция"
	// });
	var myOptions = {
		zoom: 9,
		center: center,
		mapTypeId: google.maps.MapTypeId.HYBRID
	};
	Gmap = new google.maps.Map(document.getElementById("google_map"), myOptions);

	marker = new google.maps.Marker({ 
	position: center, 
	map: Gmap,
	draggable: true,
	title: "",
	animation: google.maps.Animation.DROP,
	position_changed:function(){
		pos = marker.getPosition();
		lat_inp.val(pos.lat())
		lng_inp.val(pos.lng())
	}
	});
	// balloon.content = "Не выбрана станция";
	// balloon.maxWidth = 50;
	// balloon.open(Gmap, marker);

}

// mat_set_center = function(lat,lng,title){
// 	title = lat == 0 ? "Неуказано" : title
// 	lat = lat == 0 ? Number(35) : lat
// 	lng = lng == 0 ? Number(33) : lng

// 	coords = new google.maps.LatLng(lat,lng);
// 	Gmap.setCenter(coords)
// 	marker.setPosition(coords)
// 	marker.setTitle(title)
// 	balloon.setContent(title)
// }