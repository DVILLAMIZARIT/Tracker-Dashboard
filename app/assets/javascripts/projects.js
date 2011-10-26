// pre-load the loading image
Image1 = new Image(32, 32);
Image1.src = "/assets/animated_loading.gif";

$(document).ready(function(){

  $("td.project-goals.needs-ajax").each(function(index) {
    $(this).removeClass('needs-ajax');
    var project_id = $(this).attr("data-project_id");
    var that = $(this)
    $.ajax({
      url: "/projects/"+project_id+"/tracks",
      dataType: "html",
      success: function(data){
        that.html(data);
      },
      error: function(data){
        that.html("Error loading!");
      }
    });
  });

  $("td.project-red-flags.needs-ajax").each(function(index) {
    $(this).removeClass('needs-ajax');
    var project_id = $(this).attr("data-project_id");
    var that = $(this)
    $.ajax({
      url: "/projects/"+project_id+"/red_flags",
      dataType: "html",
      success: function(data){
        that.html(data);
      },
      error: function(data){
        that.html("Error loading!");
      }
    });
  });

});
