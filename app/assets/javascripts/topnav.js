$(document).ready(function(){
  $("span#projects").hover(
    function () {
      $("ul#projects-dropdown").css('left', $("span#projects").offset().left + 5);
      $("ul#projects-dropdown").css('top', $("span#projects").offset().top + 5);
      $("ul#projects-dropdown").show();
    },
    function () {
      $("ul#projects-dropdown").hide();
    }
  );

  $(".dropdown").hover(
    function () {
      $(this).show();
    },
    function () {
      $(this).hide();
    }
  );
});
