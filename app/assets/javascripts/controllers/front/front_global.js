$(window).load(function(){
	calculete_dom_pos();
});

$(window).resize(function(){
	calculete_dom_pos();
});

function calculete_dom_pos(){
	$(".apartments_body").height($(window).height() - $('header').height() - $('footer').height());
	$(".apartments_body .content").height($(".apartmnet_content").height() - $('.apartments_body .header_name').height() - $('.apartments_body .buttons').height());
}