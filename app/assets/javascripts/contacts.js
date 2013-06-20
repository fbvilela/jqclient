$(function(){

	$('#search_form').submit(function(){
		$('div.rowo').hide();
		$('#blank_contacts').html("<i class='icon-spinner icon-spin'></i><p>Searching...\n Please wait</p>");
		$('#blank_contacts').show();
	});
	
});

