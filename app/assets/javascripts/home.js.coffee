# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@select_picture = () ->
  $(".selected_pic").attr("class","social_network_pic")
  $(this).attr("class","selected_pic")
  return true
