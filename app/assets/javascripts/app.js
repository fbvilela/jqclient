$(window).load(function() {
  $('body').fadeIn(1200);
  
	$('.swiper-container').each(function(){
  		var current_id = $(this).attr('id');
      var mySwiper = new Swiper(this,{
  		mode:'horizontal',
  		loop: true,
  		slidesPerSlide: 1,
  		loop: false,
			simulateTouch: true,
			onSlideClick: function(){
				$('#'+current_id).swiper().swipeNext();
			},
			onSlideChangeEnd: function(){
				$('.swiper-container').each(function(){
					if( $(this).attr('id') != current_id )
					{
						$(this).swiper().swipeTo(0);
					}
				});
			}
  	});	
	});
	
  $('.swiper-container').click(function() {
   $(this).swiper().swipeTo(1);
   currentSwiper = $(this).attr('id');
   $('.swiper-container').each(function() {
    if ($(this).attr('id') != currentSwiper) $(this).swiper().swipeTo(0);
   })
  });
 
	
	
	
	
});


function slide_next(id){
	$('#'+id).swiper().swipeNext();	
}

