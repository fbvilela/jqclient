$(window).load(function() {

  $('body').fadeIn(1200);

  
	$('.swiper-container').each(function(){
    
      var mySwiper = new Swiper(this,{
  		mode:'horizontal',
  		loop: true,
  		slidesPerSlide: 1,
  		loop: false
  	}); 			
	});
	
});