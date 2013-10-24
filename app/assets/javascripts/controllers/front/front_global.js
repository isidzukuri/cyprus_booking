$(window).load(function(){
	calculete_dom_pos();
});

$(window).resize(function(){
	calculete_dom_pos();
});
$(document).ready(function(){
	calculete_dom_pos()
})
function calculete_dom_pos(){
	map_height  = $("footer").offset().top - $("#map_apartments").offset().top
	view_height = $("#apartments_view").height()
	offset = view_height - map_height
	if(offset > 0){
		$("footer").css("bottom","-" + offset + "px")
	}
	/*$("#apartments_view").size() > 0 ? $("#apartments_view").css("max-height",map_height) : ""
	$("#apartments").size() > 0 ? $("#apartments_view").css("max-height",map_height) : ""
	$(".apartments_body").height($(window).height() - $('header').height() - $('footer').height());
	$(".apartments_body .content").height($(".apartmnet_content").height() - $('.apartments_body .header_name').height() - $('.apartments_body .buttons').height());
*/
}
/*
$(document).ready(function(){
	$("nav ul a.apartments").click(function(){
		$(this).addClass("active")
		$("article").animate({ "top": "-83%" }, 500,
	      function(){
	      	console.log("1")
	      }
	    );
	    $(this).parents("ul").animate({ "bottom": "10px" },
	      function(){
	      	$("nav .search").show("slow")
	      }
	    );
	    $("article").css("position","")
	    return false
	})
})
*/