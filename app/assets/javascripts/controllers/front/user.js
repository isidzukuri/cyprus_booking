$(window).load(function(){ 

	set_blocks_position();

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
		
		// url = $('[name=filter_action]').val();
		// alert($('meta[name="csrf-token"]').attr('content'))
		// status = $('[name=filter_by_value]').val();
		// from = $('[name=date_from]').val();
		// to = $('[name=date_to]').val();
		// $.ajax({
		//   beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
		//   url: "/cabinet/"+url+"/"+status+"/"+from+"/"+to,
		//   contentType: "application/json;",
		//   dataType: "json",
		//   type:"POST"
		// });
	});

});

$(window).resize(function(){ 
	set_blocks_position();
});

function set_blocks_position(){
	if($('.bookings_list .item').length < 1){
		$('#cab_filters').hide();
		$('.bookings_list').css('overflow','hidden');	
	} 
	$('.cab_filter, .bookings_list .item').css('margin-left',0);

	list_w = $('.bookings_list').width();
	item_w = $('.bookings_list .item').width() + parseInt($('.bookings_list .item').css('margin-right'));
	items_in_line = parseInt(list_w/item_w); 
	ml = parseInt((list_w - item_w*items_in_line)/2);
	$('.bookings_list .item:nth-child('+items_in_line+'n+1)').css('margin-left',ml);

	if(parseInt($('.cab_filter').outerWidth())*$('.cab_filter').length < parseInt($('#cab_filters').width())){
		if(!ml){
			list_w = $('#cab_filters').width();
			item_w = $('.cab_filter').width() + parseInt($('.cab_filter').css('margin-right'));
			items_in_line = parseInt(list_w/item_w); 
		}
		ml = parseInt((list_w - item_w*items_in_line)/2);
		$('.cab_filter').eq(0).css('margin-left',ml);
	}else{
		filter_m = (parseInt($('#cab_filters').width()) - parseInt($('.cab_filter').width()) )/2;
		$('.cab_filter').css('margin-left',filter_m);
	}
	
	$('.bookings_list').height($('article').height() - $('.line').height()- $('.cabinet_header').height() - $('#cab_filters').height()- $('#orange_nav').height() - 80);
}