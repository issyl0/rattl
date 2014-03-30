$(document).ready(function () {
  $(".male").click(function() {
    $(".male label").addClass("active");
    $(".female label").removeClass("active");
  }); 

  $(".female").click(function() {
    $(".female label").addClass("active");
    $(".male label").removeClass("active");
  });
})