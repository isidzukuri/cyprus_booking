$(window).load(function(){
	$('#map_apartments').height($(window).height() - $('#header').height())
	initialize();
});


function initialize() {
	var mapCanvas = document.getElementById('map_apartments');
    var mapOptions = {
      center: new google.maps.LatLng(35, 33),
      zoom: 10,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(mapCanvas, mapOptions);
}