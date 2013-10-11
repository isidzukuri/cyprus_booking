$(window).load(function(){
	if($('#map_apartments').length){
		$('#map_apartments').height($(window).height() - $('#header').height())
		initialize();
	}
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



// admin
$(window).load(function(){
	initialize_map();
	admin_employment_calendar();
	$('.delete_but').click(function(){
		delete_photo($(this).data('photo_id'),$(this).data('house_id'));
		$(this).parent().remove()
	});


    $('.range_inputs span').live('click', function () {admin_remove_range($(this)); });

	$('#add_employment').click(function(){ admin_add_employment($(this)); });
		
});



function delete_photo(photo_id, house_id){
	$.ajax({
	  url: "/admin/apartaments/remove_photo/"+photo_id,
	  contentType: "application/json;",
	  dataType: "json"
	});
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



function admin_employment_calendar(){
	$.datepicker.setDefaults($.datepicker.regional['ru']);
	$("#employment_calendar").datepicker({
		dateFormat: "dd.mm.yy",
		beforeShowDay: function( d ) {
			this_date = d.getDate()+"."+(d.getMonth()+1)+"."+d.getFullYear();
			if($.inArray( this_date, disabledDays)  != -1 ){
				return [false,"","reserved"];
			}else{
				return [true,"","reserved"];
			}
      	}
	});
}



function admin_add_employment(button){
	emp_p_inputs = '<div><div class="range_inputs"><label for="from">'+adm_apartments_langs.ru.from+'</label> <input type="text" class="employment_from" required name="employment_from[]" /></div><div class="range_inputs"><label for="to">'+adm_apartments_langs.ru.to+'</label> <input type="text" class="employment_to" required name="employment_to[]" /></div><div class="ui-state-default ui-corner-all range_inputs remove_range"><span class="ui-icon ui-icon-circle-close"></span></div><div class="clear"></div></div>';
	button.before(emp_p_inputs);
	admin_atach_from_to_datepicker(button);
}


function admin_remove_range(button){
	if(button.data('id')){
		$.ajax({
		  url: "/admin/"+button.data('controller')+"/remove_"+button.data('type')+"/"+button.data('id'),
		  contentType: "application/json;",
		  dataType: "json"
		});
	}
	button.parent().parent().remove();
}

function admin_atach_from_to_datepicker(button){
	last = button.prev();
	last.find('.employment_from').datepicker({
      dateFormat: "dd.mm.yy",
      onClose: function( selectedDate ) {
        $(this).parent().parent().find('.employment_to').datepicker( "option", "minDate", selectedDate );
      }
    });
    last.find('.employment_to').datepicker({
      dateFormat: "dd.mm.yy",
      onClose: function( selectedDate ) {
        $(this).parent().parent().find('.employment_from').datepicker( "option", "maxDate", selectedDate );
      }
    });
}


window.adm_apartments_langs = {
	ru:{
		from: "от",
		to: "до"
	}
}