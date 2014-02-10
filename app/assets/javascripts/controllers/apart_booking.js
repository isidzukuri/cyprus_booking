$.Controller("ApartBooking",{
	bubbling: false,
	map_image: "/assets/ic_map.png",
	init:function(){
		var self = this
		this.setup_mask();
		this.init_tabs();
		if(this.element.find(".hotel_booking").size() < 1){
			this.init_galery();
		}
			
		else{
			this.setup_validation();
		}
	  	this.settings = {
		    zoom: 14,
		    center: new google.maps.LatLng(Number(self.element.data("lat")), Number(self.element.data("lng"))),
		    mapTypeControl: true,
		    mapTypeControlOptions: {
		      style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
		    },
		    navigationControl: true,
		    navigationControlOptions:{
		      style: google.maps.NavigationControlStyle.SMALL
		    },
		    mapTypeId: google.maps.MapTypeId.ROADMAP
	    };
	},
	init_galery:function(){
	var onMouseOutOpacity = 0.67;
	if(this.element.find('#thumbs').size() > 0)
	this.element.find('#thumbs').galleriffic({
					delay:                     2500,
					numThumbs:                 18,
					preloadAhead:              10,
					enableBottomPager:         true,
					maxPagesToShow:            7,
					imageContainerSel:         '#slideshow',
					nextPageLinkText:          '>>',
					prevPageLinkText:          '<<',
					syncTransitions:           true,
					defaultTransitionDuration: 900,
					onSlideChange:             function(prevIndex, nextIndex) {
						this.find('ul.thumbs').children()
							.eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
							.eq(nextIndex).fadeTo('fast', 1.0);
					},
					onPageTransitionOut:       function(callback) {
						this.fadeTo('fast', 0.0, callback);
					},
					onPageTransitionIn:        function() {
						this.fadeTo('fast', 1.0);
					}
				});
	},
	init_tabs:function(){
		this.element.find("#recommend_tabs").tabs();
	},

	init_map:function(){
		var self = this;
		var map = new google.maps.Map(document.getElementById("g_map"), this.settings)
		var marker  = new google.maps.Marker({
		    position: this.settings.center,
		    map: map,
		    icon: self.parent.map_image,
		});
		
	},
	".ui-tabs-nav li.map -> click":function(ev){
			this.init_map()
	},
	".pay_for_hotel a -> click":function(ev){

		ev.preventDefault()
		if($(ev.target).hasClass("login")){
			window.show_login_form()
		}
		else{
			var form = $(ev.target).parents(".pay_for_hotel").find("form")
			if(form.size() > 0){
				form.submit()	
			}
			else{
				$(ev.target).parents("form").submit()
			}
			
		}

	},
	".pay_btn.to_pay a -> click":function(ev){
		ev.preventDefault()
		if($(ev.target).hasClass("login")){
			window.show_login_form()
		}
		else{
			if(this.element.valid()){
				if($(ev.target).hasClass("send_request")){
					this.send_request(this.element)
				}
				else{
					this.element.submit()	
				}
			}
				
		}

	},
    setup_validation: function() {
      this.validator = this.element.validate({
        ignore: "",
        highlight: function(el, e_cls) {
          $(el).addClass(e_cls);
        },
        unhighlight: function(el, e_cls) {
          $(el).removeClass(e_cls);
        },
        errorPlacement: function(err,el) {
            
        },
        invalidHandler: function(event, validator){},
        onkeyup: false,
        onfocusout: false,
        focusCleanup: true,
        focusInvalid: false,
        minlength:3
      });
    },
    "input[type=text] -> change": function(ev) {
	    if(!this.parent.bubbling) this.next_unfilled_input()
    },
    setup_mask:function(){
	    this.element.find("#hotels_booking_card_attributes_exp_date").mask("99/99",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#hotels_booking_card_attributes_n_0").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#hotels_booking_card_attributes_n_1").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#hotels_booking_card_attributes_n_2").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#hotels_booking_card_attributes_n_3").mask("9999",{placeholder:" ", completed:this.next_unfilled_input})
	    this.element.find("#hotels_booking_card_attributes_cvv").mask("999",{placeholder:" ", completed:this.next_unfilled_input})
    },    
	  next_unfilled_input: function(){
	  	var unfilled = [], unfl;
	  	this.parent.bubbling = true;
	  	this.element.find("input[type=text]").each(function(){
	  		if( $(this).val() == "" || $(this).val().replace(/\s+/, "").replace(/\s+/, "").replace("/", "") == "" ) {
	  			unfilled.push($(this))
	  		}
	  	});

	  	if(unfilled.length > 0) {
	  		unfl = unfilled[0];
	  		unfilled = [];
	  		this.parent.bubbling = false;
	  		unfl.focus();
	  	}
	  },
  ".only_chars -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^а-яА-ЯA-zA-ZіЇіІЄє]/, ""))
  },
  ".only_chars_with_space -> keyup":function(ev){
    var el  = $(ev.target)
    var val = el.val().replace(/[^а-яА-Яa-zA-ZіЇіІЄє\s]/, "").split(" ")
    val.length > 2 ? val.pop() : false;
    el.val(val.join(" "))
  },
  ".only_latin -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^a-zA-Z]/, ""))
  },
  ".only_latin_with_space -> keyup":function(ev){
    var el  = $(ev.target)
    var val = el.val().replace(/[^a-zA-Z\s]/, "").split(" ")
    val.length > 2 ? val.pop() : false;
    el.val(val.join(" "))
  },
  ".only_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9]/, ""))
  },
  send_request:function(form){
  	$.ajax({
  		url:form.attr("action"),
  		data:form.serialize(),
  		type:"get",
		beforeSend:function(){
          	window.show_loader(window.I18n.cars_pay);
		},
  		dataType:"json",
  		success:function(resp){
  			if(resp.success){
  				window.show_message(window.I18n.cars_pay_success);
  				window.location.href = form.data("url") + resp.id
  			}
  			else{
  				window.show_message(resp.msg);
  			}
  		},
        error:function(){
			window.hide_loader();
			window.show_message(I18n.server_error);
        },

  	})
  }


})



