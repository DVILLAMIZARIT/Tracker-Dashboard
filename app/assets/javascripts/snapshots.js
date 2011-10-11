$(document).ready(function(){

  $("td#snapshot-stories .highlightable-story").hover(
    function() {
      $(this).addClass("highlighted-story");

      var story_id = $(this).attr("data-story_id");
      $("td#current-stories table[data-story_id="+story_id+"]").each(function() {
        $(this).addClass("highlighted-story");
        if($(this).offset().top < ( $(window).scrollTop()                    ) ) { $("div#current-up"  ).show(); }
        if($(this).offset().top > ( $(window).scrollTop()+$(window).height() ) ) { $("div#current-down").show(); }
      });
    }, 
    function() {
      $(this).removeClass("highlighted-story");

      var story_id = $(this).attr("data-story_id");
      $("td#current-stories table[data-story_id="+story_id+"]").removeClass("highlighted-story");

      $("div#current-up").hide();
      $("div#current-down").hide();
    }
  );

  $("td#current-stories .highlightable-story").hover(
    function() {
      $(this).addClass("highlighted-story");

      var story_id = $(this).attr("data-story_id");
      var count = 0;
      $("td#snapshot-stories table[data-story_id="+story_id+"]").each(function() {
        count++;
        $(this).addClass("highlighted-story");
        if($(this).offset().top < ( $(window).scrollTop()                    ) ) { $("div#snapshot-up"  ).show(); }
        if($(this).offset().top > ( $(window).scrollTop()+$(window).height() ) ) { $("div#snapshot-down").show(); }
      });
      if( count == 0) { $("div#snapshot-notfound").show(); }
    }, 
    function() {
      var story_id = $(this).attr("data-story_id");
      $(this).removeClass("highlighted-story");
      $("td#snapshot-stories table[data-story_id="+story_id+"]").removeClass("highlighted-story");

      $("div#snapshot-up").hide();
      $("div#snapshot-notfound").hide();
      $("div#snapshot-down").hide();
    }
  );

});
