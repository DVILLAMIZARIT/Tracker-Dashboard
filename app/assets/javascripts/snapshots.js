$(document).ready(function(){

  $("td#snapshot-stories .highlightable-story").hover(
    function() {
      var story_id = $(this).attr("data-story_id");
      $("td#current-stories table[data-story_id="+story_id+"]").addClass("highlighted-story");
    }, 
    function() {
      var story_id = $(this).attr("data-story_id");
      $("td#current-stories table[data-story_id="+story_id+"]").removeClass("highlighted-story");
    }
  );

  $("td#current-stories .highlightable-story").hover(
    function() {
      var story_id = $(this).attr("data-story_id");
      $("td#snapshot-stories table[data-story_id="+story_id+"]").addClass("highlighted-story");
    }, 
    function() {
      var story_id = $(this).attr("data-story_id");
      $("td#snapshot-stories table[data-story_id="+story_id+"]").removeClass("highlighted-story");
    }
  );

});
