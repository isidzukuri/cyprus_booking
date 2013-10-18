$(window).load(function(){
	$.datepicker.setDefaults($.datepicker.regional[default_lang]);
	$('.validate_form').validate()
	$('.admin_lang_menu a').click(function(){
		switch_admin_lang($(this));
	});	
	attach_filter_input();
});

$(document).ready(function(){
	Dropzone.options.adminDropzone = {
		headers: {"X-CSRF-Token" : $('meta[name="csrf-token"]').attr('content')},
		paramName: "one_photo", // The name that will be used to transfer the file
		parallelUploads:1,
		init: function() {
			this_dz = this;
			this.on("sending", function(file, xhr, formData) { 
				window.creat_new = true
				$('input[type=submit]').hide();
				$('#adminDropzone').removeClass('dropzone_holder');
				if($(".cur_id").val() != '') {
					formData.append('cur_id', $(".cur_id").val());
					window.creat_new = false;
				} 
			});
			this.on("success", function(file, response) {
				$('input[type=submit]').show();
				if(response.saved == true){
					if(window.creat_new){
						window.creat_new = false;
						$(".cur_id").val(response.cur_id);
						$('form').attr('id',response.form_id);
						$('form').append('<input name="_method" type="hidden" value="put" />')
						$('form').attr('action',$('form').attr('action')+"/"+response.cur_id);
					}
				}else{
					alert('[upload error]')
					console.error(response)
				}
				
			});
		}
	}
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