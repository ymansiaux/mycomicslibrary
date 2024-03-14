Shiny.addCustomMessageHandler('updateIsbnValue', function (arg) {
  $("#" + arg.isbn_field_id).val(arg.new_val);
  Shiny.setInputValue(arg.isbn_field_id, arg.new_val, {
    priority: "event"
  });

});
