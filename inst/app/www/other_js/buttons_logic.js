Shiny.addCustomMessageHandler('addClassToAButton', function (arg) {
  $("#" + arg.id).addClass(arg.class);
});

Shiny.addCustomMessageHandler('removeClassToAButton', function (arg) {
  $("#" + arg.id).removeClass(arg.class);
});