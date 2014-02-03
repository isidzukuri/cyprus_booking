$.Controller("SearchForm",{
	map_search:false,
	init:function(){
		this.form = (typeof(this.element.attr("method"))!="undefined") ? this.element : this.element.find("form");
		this.setup_datepicker();
	  	this.setup_validation();
	    
	},

    "input[type=text] -> change": function(ev) {
	    unfilled = []
	    this.element.find("input[type=text]:visible").each(function(){if($(this).val() == "") unfilled.push($(this))});
	    if (unfilled.length)
	      return unfilled[0].focus();
    },
    setup_datepicker:function(){
	  	this.element.find(".date_input").datepicker({ 
	      dateFormat: "dd.mm.yy",
	      minDate: 0,
	  	  numberOfMonths: 2, 
	  	  dayNamesMin: I18n.days_short,
	  	  monthNames: I18n.months,
	  	  firstDay: 1,
	      onSelect: function(selected) {
	          var idx = ($(".date_input").index($(this)) + 1);
	          if( $(".date_input").size() >= idx){
	            var next_dp = $(".date_input:eq(" + idx + ")")
	            next_dp.datepicker("option","minDate", selected)
	            setTimeout(function(){ next_dp.focus() }, 100)
	          }
	            
	      },
		  beforeShow: function() {
		      $('#ui-datepicker-div').addClass("main_datepicker");
	   	  }
	    });
    },
    setup_validation: function() {
	    this.validator = this.form.validate({
	      ignore: "",
	      highlight: function(el, e_cls) {
	        $(el).addClass(e_cls);
	      },
	      unhighlight: function(el, e_cls) {
	        $(el).removeClass(e_cls);
	      },
	      errorPlacement: function(err,el) {
	          
	      },
	      onkeyup: false,
	      onfocusout: false,
	      focusCleanup: true,
	      focusInvalid: false,
	      minlength:3
	    });
    },
	".submit  -> click":function(ev){
		ev.preventDefault();
		if(this.form.valid())
			this.submit_from()
	},
    submit_from:function(){
        self = this
        $.ajax({
          url:      self.form.attr("action"),
          data:     self.form.serialize() + "&map_search=" + self.parent.map_search,
          type:     "post",
          dataType: "json",
          beforeSend:function(){
          	window.show_loader(self.form.data("search-text"));
          },
          error:function(){
			window.hide_loader();
			window.show_message("error");
          },
          success:function(resp){
            resp.success ? self.success_call_back(resp) : self.failure_call_back(resp);            
          }
        });
    },
    init_autocomplete: function(el) {
	    var _self = this
	    var dir   = el.data("direction")
	    el.autocomplete({
	      create: function(){
	          $(".ui-autocomplete").addClass("myclass");
	      },
	      source: function(req, add) {
	      	var data = {
	      		lang:   _self.element.data('lang'),
	      		filter: req.term
	      	}
	        $.ajax({
	          url: _self.form.data("complete"),
	          type: 'get',
	          data:  data ,
	          dataType: "json",
	          success: function(response) {
	          	$('.input_loader').remove();
	            add(response)
	          }
	        });
	      },
	      open: function(event, ui) {
	        if ($(".ui-menu-item:visible").length === 1) {
	          return $($(this).data('autocomplete').menu.active).find('a:visible').trigger('click');
	        }
	      },
	      search: function(event, ui) {
	        el = $(event.target)
	        el.siblings('input[type=hidden]').val('');  
	        el.after('<span class="input_loader"></span>');
	      },
	      minLength: 2,
	      selectFirst: true,
	      autoFocus: true,
	      select: function(event, ui) {
	        input = $(event.target);
	        input.siblings('input[type=hidden]').val(ui.item.code);
	        input.val(ui.item.value);          
	        input.change();
	        return false;
	      }
	    }).data("autocomplete")._renderItem = function(ul, item) {
	      return $("<li></li>").data("item.autocomplete", item).append("<a><strong>" + item.value + "</strong></a>").appendTo(ul);
	    };
    },
    success_call_back:function(resp){
    	console.error("Redefine this method")
    },
    failure_call_back:function(resp){
    	console.error("Redefine this method")
    },
});