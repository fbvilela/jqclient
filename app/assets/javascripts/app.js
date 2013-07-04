function initialize_swipers(){
	$('.swiper-container').each(function(){
  		var current_id = $(this).attr('id');
      var mySwiper = new Swiper(this,{
  		mode:'horizontal',
  		loop: true,
  		slidesPerSlide: 1,
  		loop: false,
			simulateTouch: true,
			onSlideChangeEnd: function(){
				if( $('.swiper-container.open').length > 0 ) 
				{ 
					$('.swiper-container.open').swiper().swipeTo(0);
					$('.swiper-container.open').removeClass("open");
				}
				if( mySwiper.activeSlide == 0 )
				{
					$('#'+current_id).removeClass("open");
					$('#'+current_id).addClass("closed");
				}
				else
				{
					$('#'+current_id).removeClass("closed");
					$('#'+current_id).addClass("open");
				}				
			}
  	});	
	});
		
}//function 



function init_custom_swipers(){
	$('.slide2').hide();
	$('.slide1').css("width", "100%");
	$('.slide1').click(function(){
		$(this).parents('.swiper-container').find('.slide2').show(); //Just to remove the display:none
		$(this).parents('.swiper-container').swiper({
			onSlideChangeEnd: function(){
				//insert the code to make them close automatically
			}
		}).swipeNext();
	});
}


$(window).load(function() {
  $('body').fadeIn(1200);	
	init_custom_swipers();
});


function slide_next(id){
	$('#'+id).swiper().swipeNext();	
}


$(function(){
	$('a[data-remote=true]').bind('ajax:beforeSend', function(){
	  $('#show_loading').show();
	});
	
});
