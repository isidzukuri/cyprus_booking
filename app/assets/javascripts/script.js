/* Functions for info and error popups*/
window.show_info_popup = function(where, text, at_top) {
  var popup, top;
  if (at_top == null) {
    at_top = false;
  }
  popup = $('.b_errors:eq(0)');
  popup.find('span').text(text);
  popup.css({
    width: where.width()
  });
  if (at_top) {
    popup.addClass('b_errors_fields');
    top = where.offset().top - where.height() - popup.height();
  } 
  else {
    popup.removeClass('b_errors_fields');
    top = where.offset().top + where.height() + 15;
  }
  popup.css({
    top: top,
    left: where.offset().left + (where.outerWidth() / 2) - (popup.outerWidth() / 2)
  });
  popup.show();
};

window.show_error_popup = function(where, text, idx ,at_top) {
  var popup, top;
  if (at_top == null) {
    at_top = false;
  }
  popup = $('.b_errors:eq(0)');
  popup = popup.clone();
  popup.addClass("errors_block _idx_" + idx);
  $("body").append(popup);
  popup.find('span').text(text);
  popup.css({
    width: where.width()
  });
  if (at_top) {
    popup.addClass('b_errors_fields');
    top = where.offset().top - where.height() - popup.height();
  } 
  else {
    popup.removeClass('b_errors_fields');
    top = where.offset().top + where.height() + 15;
  }
  popup.css({
    top: top,
    left: where.offset().left + (where.outerWidth() / 2) - (popup.outerWidth() / 2)
  });
  popup.show();
};

window.hide_info_popup = function() {
  $('.b_errors').hide();
  $('.errors_block').show();
};
window.hide_error_popup = function(idx) {
  $('.b_errors._idx_' + idx).remove();
};

window.enadle_popups = function(){
  $('*[data-popup-info]').each(function(i, k) {
    var el;
    el = $(this);
    el.focus(function(ev) {
      window.show_info_popup(el, el.data('popup-info'), true);
    });
    el.blur(function(ev) {
      window.hide_info_popup();
    });
  });
}

window.main_height = function(){
  return $(document).height()  - ($("#header").height() + $("#footer").height())
}

window.show_login_form = function(){
  $(".popup").hide();
  $("#shadow, #login_window").show();
}
window.close_popup = function(){
  $("#shadow").hide();
}
window.show_restor_pass = function(){
  $(".popup").hide();
  $("#shadow, #restore").show();
}
window.show_loader  = function(text){
  $(".popup").hide();
  $("#loader_text p").text(text)
  $("#shadow, #bg_loader").show();
}
window.hide_loader  = function(){
  $("#shadow").hide();
}
window.show_message = function(text){
  $(".popup").hide();
  $("#loader_notice p").text(text)
  $("#shadow, #loader_notice").show();
}

$(function() {

   /* Google Maps prototypes*/
	 (function () {
	 	if(typeof(google) != "undefined"){
		 google.maps.Map.prototype.markers = new Array();
		 google.maps.Map.prototype.addMarker = function(marker) {
		    this.markers[this.markers.length] = marker;
		  };

		  google.maps.Map.prototype.getMarkers = function() {
		    return this.markers
		  };
		  google.maps.Map.prototype.clearMarkers = function() {
		    for(var i=0; i<this.markers.length; i++){
		      this.markers[i].setMap(null);
		   }

		   this.markers = [];
		  };
	 	}

	})();
  $(".info_link").tooltip({
    position: { my: "center top", at: "left bottom"}
  });
  $(".info_link").click(function(){
    return false
  })
  /* Enable plugin for checboxes ,radio,select */
  $('input[type="radio"], input[type="checkbox"]').iCheck({
    checkboxClass: 'icheckbox_minimal',
    radioClass:    'iradio_minimal',
  });
  $('input').on('ifClicked', function(ev){    
    $(ev.target).change()
  });
  $("select").selectbox();
  
  /* Enable controllers for elements */
  $('*[data-auto-controller]').each(function() {
    var plg;
    if ((plg = $(this)['attach' + $(this).data('auto-controller')])) {
      return plg.call($(this));
    }
  });
  var block_to_hide = ["currency_block","lang_block","user_menu_block"]
  $(document).click(function(ev){
    var target = $(ev.target);
    $.each(block_to_hide,function(k,el_){
      el = $("." + el_)
      if(el.size() < 1)
        return;
      if(!el.is(":visible"))
        return;
      if(target.hasClass(el_) || target.parents("." + el_).size() > 0 || target.hasClass(el_.replace("_block","")))
        return;
      el.hide();
    })
  })
 /* Enable info popups */

  window.enadle_popups()
  $('#ui-datepicker-div').click(function(e){
    e.stopPropagation();
  });

  $(document).click(function(e){
    var target = e.target;
    if($(target).hasClass('ui-corner-all')){ return; }
    if(!$(target).hasClass('hasDatepicker') &&  $('#ui-datepicker-div').is(":visible")) {
      $(".hasDatepicker").datepicker("hide");
    }
  });

});

Array.prototype.unset = function(value) {
    if(typeof(this.indexOf) == "function" && this.indexOf(value) != -1) {
        this.splice(this.indexOf(value), 1);
    }   
}
