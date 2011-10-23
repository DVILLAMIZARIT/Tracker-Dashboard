$(document).ready(function(){

  $("td.project-goals").each(function(index) {
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

  $("td.project-red-flags").each(function(index) {
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
