$.Controller("HotelResult",{
	session_id:"",
	init:function(){
		var data = {key:this.element.data("key"),location:this.element.data("location"),session_id:this.element.data("id")}
		this.load_hotels(data)
	},
	"#sort -> change":function(ev){
		var data = {sort:$(ev.target).val()}
	},

	load_hotels:function(data){
		var self = this
		$.ajax({
			url:"/hotels/load_hotels",
			type:"get",
			dataType:"json",
			data:data,
			success:function(resp){
				if(resp.success){
					self.element.find(".result_list").append(resp.html)
					self.load_hotels(resp.data)
				}
				else{
					$(".h_loader").hide()
				}
			},
			error:function(){
				$(".h_loader").hide()
			}
		})
	},
})