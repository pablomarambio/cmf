$(document).ready(function(){
  $("#pics img").click( function(){
    $("#pics img").attr("class","social_network_pic");
    $(this).attr("class","selected_pic");
    $("#user_main_picture").val($(this).attr("src"));
  }); 

});
