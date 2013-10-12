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
	$.datepicker.setDefaults($.datepicker.regional['ru']);
	initialize_map();
	admin_employment_calendar();
	admin_price_calendar();
	$('.delete_but').click(function(){
		delete_photo($(this).data('photo_id'),$(this).data('house_id'));
		$(this).parent().remove()
	});


    $('.range_inputs span').live('click', function () {admin_remove_range($(this)); });

	$('#add_employment').click(function(){ admin_add_range($(this),'employment',disabledDays); });
	$('#add_price').click(function(){ admin_add_range($(this),'price',price_disabledDays); });
	$('#price_calendar td a').click(function(){ return false;});	
		
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
	$("#employment_calendar").datepicker({
		dateFormat: "dd.mm.yy",
		numberOfMonths: 3,
		beforeShowDay: function( d ) {
			this_date = d.getDate()+"."+(d.getMonth()+1)+"."+d.getFullYear();
			if($.inArray( this_date, disabledDays)  != -1 ){
				return [false,"",adm_apartments_langs.ru.busy];
			}else{
				return [true,"",adm_apartments_langs.ru.free];
			}
      	}
	});
}

function admin_price_calendar(){
	$("#price_calendar").datepicker({
		dateFormat: "dd.mm.yy",
		numberOfMonths: 3,
		beforeShowDay: function( d ) {
			this_date = d.getDate()+"."+(d.getMonth()+1)+"."+d.getFullYear();
			key = $.inArray( this_date, price_disabledDays);
			if(key != -1){
				return [false, "price_color", price_values[key]+" "+default_currency];
			}else{
				return [true,"",default_price+" "+default_currency];
			}
      	}
	});
	$('.price_color').each(function( index ) {
	  color = parseInt($(this).attr('title')) + "fffff";
	  color = "#"+color.substring(0, 6);
	  $(this).find('span').css('background',color);
	});
}



function admin_add_range(button,type,disabled){
	custom_field = (type == 'price') ? '<div class="range_inputs"><label>'+adm_apartments_langs.ru.price+'</label> <input type="text" class="'+type+'_inp" required name="'+type+'_range_value[]" /></div>' : '';
	emp_p_inputs = '<div><div class="range_inputs"><label for="from">'+adm_apartments_langs.ru.from+'</label> <input type="text" class="'+type+'_from" required name="'+type+'_from[]" /></div><div class="range_inputs"><label for="to">'+adm_apartments_langs.ru.to+'</label> <input type="text" class="'+type+'_to" required name="'+type+'_to[]" /></div>'+custom_field+'<div class="ui-state-default ui-corner-all range_inputs remove_range"><span class="ui-icon ui-icon-circle-close"></span></div><div class="clear"></div></div>';
	button.before(emp_p_inputs);
	admin_atach_from_to_datepicker(button,type,disabled);
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

function admin_atach_from_to_datepicker(button,type,disabled){
	last = button.prev();
	last.find('.'+type+'_from').datepicker({
      dateFormat: "dd.mm.yy",
      onClose: function( selectedDate ) {
        $(this).parent().parent().find('.'+type+'_to').datepicker( "option", "minDate", selectedDate );
      },
      beforeShowDay: function( d ) {
			this_date = d.getDate()+"."+(d.getMonth()+1)+"."+d.getFullYear();
			if($.inArray( this_date, disabled)  != -1 ){
				return [false,"",adm_apartments_langs.ru.busy];
			}else{
				return [true,"",adm_apartments_langs.ru.free];
			}
      	}
    });
    last.find('.'+type+'_to').datepicker({
      dateFormat: "dd.mm.yy",
      onClose: function( selectedDate ) {
        $(this).parent().parent().find('.'+type+'_from').datepicker( "option", "maxDate", selectedDate );
      },
      beforeShowDay: function( d ) {
			this_date = d.getDate()+"."+(d.getMonth()+1)+"."+d.getFullYear();
			if($.inArray( this_date, disabled)  != -1 ){
				return [false,"",adm_apartments_langs.ru.busy];
			}else{
				return [true,"",adm_apartments_langs.ru.free];
			}
      	}
    });
}


window.adm_apartments_langs = {
	ru:{
		from: "от",
		to: "до",
		busy: "Зарезервировано",
		free: "Свободно",
		price: "цена"
	}
}