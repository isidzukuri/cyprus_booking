
$.Controller("OfferController",{
	map_image: "/assets/ic_map.png",
	init:function(){
		Base_coords   = 
		this.id = Number(this.element.data("id"))
		var coords = this.id ? new google.maps.LatLng(Number(this.element.data("lat")), Number(this.element.data("lng"))) : new google.maps.LatLng(35, 33);
	    var zoom   = this.id ? 12 : 9; 
	    this.init_map(coords,zoom);
	    if(this.id){
	    	this.element.find('.description_tabs_block').tabs();
	    }
	    else{
	    	this.element.find('.description_tabs_block').tabs({disabled: [1,2]});
	    }
	    this.setup_validation();
	    this.init_photo_loader();
	},
	".pay_btn a -> click":function(ev){
		ev.preventDefault()
		if(this.element.valid()){
			this.element.submit();
		}

	},
	"#house_street, #house_country_id, #house_city_id, #house_house_number -> change":function(ev){
		var val = this.element.find("#house_country_id option:selected").text() + " " +
		this.element.find("#house_city_id option:selected").text() + " " +
		this.element.find("#house_street").val() + " " +
		this.element.find("#house_house_number").val()
		$("#house_full_address").val(val)
	},
	".dz-error-mark -> click":function(ev){
		ev.preventDefault();
		this.delete_photo($(ev.target).data("id"))
	},
  ".only_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9]/, ""))
  },
	"#adminDropzone h5 ->click":function(ev){
		$("#adminDropzone").click()
	},
	delete_photo:function(photo_id){
		var self = this;
		$.ajax({
		  url: "/cabinet/offers/remove_photo/",
		  data:{photo_id:photo_id,id:self.id},
		  type: "get",
		  dataType: "json",
		  success:function(resp){
		  	if(resp.success){
		  		self.element.find("#photo_" + photo_id).remove()
		  	}
		  }
		});
	},
	init_photo_loader:function(){
		var self = this
		Dropzone.options.adminDropzone = {
			headers: {"X-CSRF-Token" : $('meta[name="csrf-token"]').attr('content')},
			paramName: "one_photo", 
			parallelUploads:1,
			init: function() {
				this_dz = this;
				this.on("sending", function(file, xhr, formData) { 
					window.creat_new = true
					$('input[type=submit]').hide();
					$('#adminDropzone').removeClass('dropzone_holder');
					formData.append('cur_id', self.id);
						window.creat_new = false;
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
        onkeyup: false,
        onfocusout: false,
        focusCleanup: true,
        focusInvalid: false,
        minlength:3
      });
    },
	init_map:function(coords,zoom){
		lat_inp = this.element.find("#house_latitude")
		lng_inp = this.element.find("#house_longitude")
		this.settings = {
		    zoom: zoom,
		    center: coords,
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
		var self = this;
		var map = new google.maps.Map(document.getElementById("g_map"), this.settings)
		var marker  = new google.maps.Marker({
		    position: this.settings.center,
		    map: map,
		    draggable:true,
		    icon: self.parent.map_image,
		    	position_changed:function(){
				pos = marker.getPosition();
				lat_inp.val(pos.lat())
				lng_inp.val(pos.lng())
			}
		});
		
	},
});

