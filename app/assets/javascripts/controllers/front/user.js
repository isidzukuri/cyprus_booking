$(window).load(function(){ 
	user_menu = $('#header_user_menu')

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




	$(".header_right li.icon_guests a").click(function(){
		if(!$(this).hasClass('login')){
			if(!user_menu.hasClass('shown')){
				user_menu.stop().animate({top: 30 }, 300, function(){$(this).toggleClass("shown")});
			}else{
		    	user_menu.stop().animate({top: -400 }, 300, function(){$(this).toggleClass("shown")});
			}
		}

		return false;
	});

	user_menu.mouseleave(function(){
		$(this).stop().animate({top: -400 }, 300, function(){$(this).toggleClass("shown")});
	});

});

$(window).resize(function(){ 
	set_blocks_position();
});

function set_blocks_position(){
	// $('article').height($(window).height() -$('header').height()-$('footer').height());
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