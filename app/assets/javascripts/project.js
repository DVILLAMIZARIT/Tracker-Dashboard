// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $("img.help").tooltip();

  $(".reverse_tooltip").tooltip({ position: "bottom center", 
                                  events: { a: "ready" },
                                  tipClass: "reverse-tooltip" });

  $(".tooltip_default_on").each(function() { $(this).mouseover(); })
});

