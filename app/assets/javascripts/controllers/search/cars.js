//= require ./form
$.Controller("CarsSearchForm","SearchForm",{
	init:function(){
		this.super_call("init");
		this.advanced_from = this.element.find(".advaced_from");
		this.disable_selects();
	},
    "input[type=text] -> change": function(ev) {
    	
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
	            $(this).change()
	          }
	      },
		  beforeShow: function() {
		      $('#ui-datepicker-div').addClass("main_datepicker");
	   	  }
	    });
    },
	".chk input -> change":function(ev){
		if($(ev.target).is(":checked")){
			this.advanced_from.show()
		}
		else{
			console.log(this.advanced_from)
			this.advanced_from.hide()
		}
	},
	"select -> change":function(ev){
		var action    = $(ev.target).data("action");
		if(action){
			var call_back = $(ev.target).data("call-back");
			var loc 	  = $(ev.target).attr("id") == "cars_search_dropp_off_attributes_location" ? this.element.find("#cars_search_dropp_off_attributes_location").val() : this.element.find("#cars_search_pick_up_attributes_location").val()
			var data  	  = {id:$(ev.target).val(),pick_loc:loc}
			var idx       = this.element.find("select").index($(ev.target))
			if(idx > 0){
				data['prev'] = this.element.find("select:eq(" + (idx-1) + ")").val()
			}
			this.cleat_selects(idx);
			this.send_request(action,data,call_back)
		}
		if($(ev.target).attr("id")=="cars_search_dropp_off_attributes_location"){
			var input = this.element.find("#cars_search_pick_up_attributes_date");
			input.removeAttr("disabled")
			input.focus()
		}
	},
	"input -> change":function(ev){
		var action    = $(ev.target).data("action");
		if(action){
			var call_back = $(ev.target).data("call-back");
			var data  	  = {id:$(ev.target).val(),pick_loc:this.element.find("#cars_search_pick_up_attributes_location").val()}
			this.send_request(action,data,call_back)
		}
	},
	"#cars_search_pick_up_attributes_time -> change":function(ev){
		var input = this.element.find("#cars_search_dropp_off_attributes_date");
		input.removeAttr("disabled")
		input.focus()
	},
	disable_selects:function(){
		this.element.find("select").selectbox("enable")
		this.element.find("select[disabled=disabled]").selectbox("disable")
	},
	cleat_selects:function(idx){
		var selects = this.element.find("select")
		selects.each(function(){
			if(selects.index($(this))>idx){
				$(this).attr("disabled","disabled");
				$(this).selectbox("detach");
				$(this).html($(this).find("option:eq(0)"));
				$(this).selectbox("attach");
			}
		})
		this.disable_selects();
	},
	send_request:function(url,data,call_back){
		var self = this
		$.ajax({
			url:url,
			data:data,
			type:"get",
			dataType:"json",
			success:function(resp){
				if(resp.success){
					self[call_back](resp.options)
				}
				else{
					self.show_error(resp.text)
				}
				
			}
		});
	},

	render_pick_up_city:function(data){
		this.render_select('cars_search_pick_up_attributes_city',data);
		this.open_select('cars_search_pick_up_attributes_city');
	},
	render_pick_up_location:function(data){
		this.render_select('cars_search_pick_up_attributes_location',data);
		this.open_select('cars_search_pick_up_attributes_location');
	},
	render_dropp_off_country:function(data){
		this.render_select('cars_search_dropp_off_attributes_country',data);
		if(this.advanced_from.is(":visible")){
			this.open_select('cars_search_dropp_off_attributes_country');
		}
		else{
			this.element.find("#cars_search_pick_up_attributes_date").removeAttr("disabled").focus()
		}
	},	
	render_dropp_off_city:function(data){
		this.render_select('cars_search_dropp_off_attributes_city',data);
		this.open_select('cars_search_dropp_off_attributes_city');
	},
	render_dropp_off_location:function(data){
		this.render_select('cars_search_dropp_off_attributes_location',data);
		this.open_select('cars_search_dropp_off_attributes_location');
	},
	render_pick_up_time:function(data){
		this.render_select('cars_search_pick_up_attributes_time',data);
		this.open_select('cars_search_pick_up_attributes_time');
	},
	render_dropp_off_time:function(data){
		this.render_select('cars_search_dropp_off_attributes_time',data);
		this.open_select('cars_search_dropp_off_attributes_time');
	},
	render_select:function(id,data){
		var select = this.element.find("#" + id)
		select.selectbox("detach");
		select.removeAttr("disabled");
		select.html($(data));
		select.selectbox("attach")
		this.disable_selects()
	},
	open_select:function(id){
		var select = this.element.find("#" + id)
		select.selectbox("open")
	},
	success_call_back:function(resp){
		window.location.href = resp.url
	},
    failure_call_back:function(resp){
    	self.show_error(resp.text)
    },
    show_error:function(text){
    	alert(text);
    }

});