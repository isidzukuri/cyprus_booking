$(window).load(function(){
	$.datepicker.setDefaults($.datepicker.regional[default_lang]);
	$('.validate_form').validate()
	$('.admin_lang_menu a').click(function(){
		switch_admin_lang($(this));
	});	
	attach_filter_input();
});

function attach_filter_input(){
	$('.number').filter_input({regex:'[0-9.]'});
	$('.digits').filter_input({regex:'[0-9]'});
}

function switch_admin_lang(button){
	to_lang = button.attr('lang');
	$('.lang_active').removeClass('lang_active');
	button.addClass('lang_active');
	$('.many_langs').addClass('lang_hidden');
	$('.many_langs[lang='+to_lang+']').removeClass('lang_hidden');
}