Shiny.addCustomMessageHandler('waitForModalModifyBookInCollection', function (arg) {

  var waitForEl = function (selector, callback) {
    if (jQuery(selector).length) {
      callback();
    } else {
      setTimeout(function () {
        waitForEl(selector, callback);
      }, 100);
    }
  };

  var setDefaultValuesWhenModalShows = function () {
    console.log("le modal est ici");
    Shiny.setInputValue(arg.id_note, arg.note_initial_value);
    Shiny.setInputValue(arg.id_format, arg.format_initial_value);
    Shiny.setInputValue(arg.id_etat, arg.etat_initial_value);
  }

  waitForEl(
    "#" + arg.modalToWaitFor, () => {
      setDefaultValuesWhenModalShows();

      $("#" + arg.id_note).on("change", function (e) {
        Shiny.setInputValue(
          arg.id_note,
          $("#" + arg.id_note).val(),
          { priority: 'event' });
      });

      $("#" + arg.id_format).on("change", function (e) {
        Shiny.setInputValue(
          arg.id_format,
          $("#" + arg.id_format).val(),
          { priority: 'event' });
      });

      $("#" + arg.id_etat).on("change", function (e) {
        Shiny.setInputValue(
          arg.id_etat,
          $("#" + arg.id_etat).val(),
          { priority: 'event' });
      });
    }
  );
});
