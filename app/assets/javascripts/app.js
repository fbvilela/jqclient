// Initialize your app
var myApp = new Framework7({
  // If it is webapp, we can enable hash navigation:
      pushState: true,
 
      // Hide and show indicator during ajax requests
      onAjaxStart: function (xhr) {
          myApp.showIndicator();
      },
      onAjaxComplete: function (xhr) {
          myApp.hideIndicator();
      }
});

// Export selectors engine
var $$ = Framework7.$;

// Add view
var mainView = myApp.addView('.view-main', {
    // Because we use fixed-through navbar we can enable dynamic navbar
    dynamicNavbar: true,
    cacheDuration:	0
});

// Event listener to run specific code for specific pages
$$(document).on('pageInit', function (e) {

		cacheDuration:	0
    
    $("#filter_contacts").fastLiveFilter(".filterable");
    
      
    $('.actions').on('click', function () {
        var contact_id = $(this).data('contact');
        var contact_phone = $(this).data('phone');
        var contact_email = $(this).data('email');
		    var buttons1 = [
		        {
		            text: $(this).data('name'),
		            label: true
		        },
		        {
		            text: "<a href='tel:"+ contact_phone + "' class='external'>Call</a>",
		        },
		        {
		            text: "<a href='mailto:"+ contact_email + "' class='external'>Email</a>",
		        },
		        {
		            text: 'Edit',
                onClick: function () {
                  $.get('/contacts/'+contact_id+'/edit', function(html){
                    $('#popup').html(html);
                    $('#popup').on("close", function(){
                      $('#editing_contact').submit(function(e){
                            var postData = $(this).serializeArray();
                            var formURL = $(this).attr("action");
                            $.ajax(
                            {
                                url : formURL,
                                type: "POST",
                                data : postData,
                                success:function(data, textStatus, jqXHR) 
                                {
                                    //data: return data from server
                                    myApp.addNotification({
                                      title: 'Success!',
                                      message: 'Contact saved',
                                      hold: 2000
                                    });
                                },
                                error: function(jqXHR, textStatus, errorThrown) 
                                {
                                    //if fails      
                                }
                            });
                            e.preventDefault(); //STOP default action
                            e.unbind(); //unbind. to stop multiple form submit.
                      });
                      
                      
                      $('#editing_contact').submit();
                    });
                    myApp.popup('#popup');
                  });
                }
		        },
		        {
		            text: 'Add a note',
		            onClick: function () {
                  $.get('/contacts/'+ contact_id + '/add_note', function(html){
                    $('#popup').html(html);
                    $('#popup').on("close", function(){
                      $('#adding_note').submit(function(e){
                            var postData = $(this).serializeArray();
                            var formURL = $(this).attr("action");
                            $.ajax(
                            {
                                url : formURL,
                                type: "POST",
                                data : postData,
                                success:function(data, textStatus, jqXHR) 
                                {
                                    //data: return data from server
                                    myApp.addNotification({
                                      title: 'Success!',
                                      message: 'Note added to contact',
                                      hold: 2000
                                    });
                                },
                                error: function(jqXHR, textStatus, errorThrown) 
                                {
                                    //if fails      
                                }
                            });
                            e.preventDefault(); //STOP default action
                            e.unbind(); //unbind. to stop multiple form submit.
                      });
                      $("#adding_note").submit();  
                    });
                    myApp.popup("#popup");  
                  });
                }
		        }
		    ];
		    var buttons2 = [
		        {
		            text: 'Cancel',
		            red: true
		        }
		    ];
		    var groups = [buttons1, buttons2];
		    myApp.actions(groups);
        
		});
    
    
    
    $(".searchbar-button").click(function(){ 
      var search_args = $(".search_input").val();
      myApp.showIndicator();
      $.post("/contacts/search", { search: search_args }, function(html){
        myApp.hideIndicator();
        $("#result_list").html(html);
        //mainView.loadContent(html, true);
        $$(document).trigger("pageInit");
      });
    });
    
	
});
