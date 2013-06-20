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
	
  $('.swiper-container').click(function() {
   	if( $('.swiper-container.open').length > 0 ) 
		{ 
			$('.swiper-container.open').swiper().swipeTo(0);
			$('.swiper-container.open').removeClass("open");
		}
   $(this).removeClass("closed");
	 $(this).addClass("open");
   $(this).swiper().swipeTo(1);
  });
	
	
}//function 


$(window).load(function() {
  $('body').fadeIn(1200);	
	initialize_swipers();	
});


function slide_next(id){
	$('#'+id).swiper().swipeNext();	
}


$(function(){
/** this was an attempt to animate the rows.*/ 	
/**	$('.rowo').css('margin-top', '1024px');
	$('.rowo').delay(200).animate({
			marginTop: '0px'
		}, 2000, 'easeInOutExpo');
*/
	
	$('a[data-remote=true]').bind('ajax:beforeSend', function(){
	  $('#show_loading').show();
	});
	
});
