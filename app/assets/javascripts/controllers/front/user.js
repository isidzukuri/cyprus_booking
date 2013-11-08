$(window).load(function(){ 


	$('.b_calendar').attachCalendarController();
	set_blocks_position();
	init_city_autocomplete();
	$(".cabinet_form").mCustomScrollbar({
	  advanced: {
	    updateOnContentResize: true,
	    updateOnBrowserResize: true
	  }
	});

	$('.disabled_link').click(function(){
		return false;
	});

	$.datepicker.setDefaults($.datepicker.regional['ru']);
	$('[name=date_from]').datepicker({
      dateFormat: "dd.mm.yy",
      onClose: function( selectedDate ) {
        $('[name=date_to]').datepicker( "option", "minDate", selectedDate );
      }
    });
    $('[name=date_to]').datepicker({
      dateFormat: "dd.mm.yy",
      onClose: function( selectedDate ) {
        $('[name=date_from]').datepicker( "option", "maxDate", selectedDate );
      }
    });

    $('.custom_dropdown').mousedown(function(){
    	$(this).blur();
    	offset = $(this).offset();
    	dropdown = $('.filters_select[related='+$(this).attr('name')+']');
		if(!dropdown.hasClass('shown')){
			dropdown.show().css(offset).toggleClass("shown");
		}else{
	    	dropdown.hide().toggleClass("shown");
		}
		return false;    	
    });

    $('.custom_dropdown').keydown(function(){
    	$(this).blur()
    	return false;
    });

    $('.filters_select a').mousedown(function(){
		related = $(this).parents('.filters_select').attr('related');
		$('[name='+related+'_value]').val($(this).attr('by'));
		$('[name='+related+']').val($(this).text()).trigger('change');	
		$(this).parents('.filters_select').toggleClass("shown").hide();	
		return false;
	});

    $('.filters_select').mouseleave(function(){
    	if($(this).hasClass('shown')) $(this).toggleClass("shown").hide();
	});
	$('body').mousedown(function(){
    	if($('.filters_select').hasClass('shown')) $('.filters_select').toggleClass("shown").hide();
    	//if(user_menu.hasClass('shown')) user_menu.stop().animate({top: -400 }, 300, function(){$(this).toggleClass("shown")});
	});


	user_menu = $('#header_user_menu');
	$(".header_right li.icon_guests a").click(function(){
		if(!$(this).hasClass('login')){
			if(!user_menu.hasClass('shown')){
				user_menu.stop().animate({top: 30 }, 300, function(){$(this).toggleClass("shown")});
			}else{
		    	user_menu.stop().animate({top: -400 }, 300, function(){$(this).toggleClass("shown")});
			}
			return false;
		}
	});

	user_menu.mouseleave(function(){
		$(this).stop().animate({top: -400 }, 300, function(){$(this).toggleClass("shown")});
	});


	$('.cab_filter').change(function(){
		items_container = $('.bookings_list>div>div');
		items_container.empty().append("<div class='basic_loader'></div>");
		url = $('[name=filter_action]').val();
		status = $('[name=filter_by_value]').val();
		from = $('[name=date_from]').val();
		to = $('[name=date_to]').val();
		$.ajax({
		  beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
		  url: "/cabinet/"+url,
		  data: JSON.stringify({status:status,to:to,from:from}),
		  contentType: "application/json;",
		  dataType: "json",
		  type:"POST",
		  success:function(response){
		  	items_container.empty().append(response.html);
		  	$('.bookings_list').mCustomScrollbar("destroy");
		  	$(".bookings_list").mCustomScrollbar();
		  }
		});
	});


	$('#cabinet .edit_ico').click(function(){
		drop = $(this).parent().find('.filters_select');
		drop.show();
		drop.parent().mouseleave(function(){drop.hide()});
	});



	attach_filter_input();

	$('.front_validate_form').validate({
	  errorPlacement: function(error, element) { 
	    element.addClass("red_border");
	  }
	});

	$("input").bind("keydown change", function() {
		$(this).removeClass("red_border");
	});

});

$(window).resize(function(){ 
	set_blocks_position();
});

function show_item_actions(){

}

function attach_filter_input(){
	$('.number').filter_input({regex:'[0-9.]'});
	$('.digits').filter_input({regex:'[0-9]'});
}

function set_blocks_position(){
	$('.bookings_list').removeAttr('style');
	$('#cab_filters').removeAttr('style');
	if($('.bookings_list .item').length < 1){
		$('#cab_filters').hide();
		$('.bookings_list').css('overflow','hidden');	
	} 
	// $('.cab_filter, .bookings_list .item').css('margin-left',0);

	list_w = $('.bookings_list').width();
	item_w = $('.bookings_list .item').width() + parseInt($('.bookings_list .item').css('margin-right'));
	items_in_line = parseInt(list_w/item_w); 
	ml = parseInt((list_w - item_w*items_in_line)/2);
	// $('.bookings_list .item:nth-child('+items_in_line+'n+1)').css('margin-left',ml);
	$('.bookings_list').css('padding-left',ml).width($('.bookings_list').width()-ml);

	// if(parseInt($('.cab_filter').outerWidth())*$('.cab_filter').length < parseInt($('#cab_filters').width())){
	// 	// if(!ml){
	// 	// 	list_w = $('#cab_filters').width();
	// 	// 	item_w = $('.cab_filter').width() + parseInt($('.cab_filter').css('margin-right'));
	// 	// 	items_in_line = parseInt(list_w/item_w); 
	// 	// }
	// 	// ml = parseInt((list_w - item_w*items_in_line)/2);
	// 	// $('.cab_filter').eq(0).css('margin-left',ml);

	// }else{
	// 	// filter_m = (parseInt($('#cab_filters').width()) - parseInt($('.cab_filter').width()) )/2;
	// 	// $('.cab_filter').css('margin-left',filter_m);
	// }
	$('#cab_filters').css('padding-left',ml).width($('#cab_filters').width()-ml);
	$('article').height($(window).height() - $('header').height() - $('footer').height())
	$('.bookings_list').height($('article').height() - $('.line').height()- $('.cabinet_header').height() - $('#cab_filters').height()- $('#orange_nav').height() - 80);
	$('.user_profile, .cabinet_form').height($('article').height() - $('.line').height()- $('.cabinet_header').height()-80);

	// $('.cabinet_form').height($('article').height() - $('.line').height()- $('.cabinet_header').height()-80);
	
	// $('#wrapper').height($(window).height())
	
}


function init_city_autocomplete() {
	$("[name=city_name]").autocomplete({
	  source: '/apartments/complete',
	  create: function(a, b) {
	    return $($(this).data("autocomplete").bindings[1]).addClass("myclass");
	  },
	  search: function(event, ui) {
	    $(event.target).prev().val('');
	    // G_map.setCenter(Base_coords);
	    // return G_map.setZoom(9);
	  },
	  minLength: 2,
	  open: function() {
	    if ($(".ui-menu-item:visible").length === 1) {
	      return $($(this).data('autocomplete').menu.active).find('a:visible').trigger('click');
	    }
	  },
	  select: function(event, ui) {
	    var code_input, input, lat_lng, text;
	    input = $(event.target);
	    code_input = input.parents(".jNiceInputWrapper").siblings('input[type=hidden]');
	    text = ui.item.name_ru + ", " + ui.item.country;
	    input.val(text);
	    code_input.val(ui.item.id);
	    input.change();
	    code_input.change();
	    lat_lng = new google.maps.LatLng(ui.item.lat, ui.item.lng);
	    // G_map.setCenter(lat_lng);
	    // G_map.setZoom(13);
	    return false;
	  }
	}).each(function() {
	  return $(this).data("autocomplete")._renderItem = function(ul, item) {
	    return $("<li></li>").data("item.autocomplete", item).append("<a><strong>" + item.name_ru + "</strong>  " + item.country + "</a>").appendTo(ul);
	  };
	});
}

