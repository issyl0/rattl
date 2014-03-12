$(document).ready(function () {
  $(".male").click(function() {
    $(".male label").addClass("active");
    $(".female label").removeClass("active");
  }); 

  $(".female").click(function() {
    $(".female label").addClass("active");
    $(".male label").removeClass("active");
  });

  // IL: Skills haven't been merged into the develop branch yet.
  // $("form.skills input.addskill").click(function() {
  //   $("form.skills .field .clone:first-child").clone().appendTo("form.skills .field");
  //   $("form.skills .field:first-child input#skill").val("");
  // });

  // $("form.skills input.remskill").click(function() {
  //   $('.clone:last-child').remove();
  // });
})