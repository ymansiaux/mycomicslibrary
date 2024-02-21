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

  var setInputValuesWhenValueChanges = function (id) {
    $("#" + id).on("change", function (e) {
      Shiny.setInputValue(
        id,
        $("#" + id).val(),
        { priority: 'event' });
    });
  }

  var setDefaultValuesWhenModalShows = function () {
    console.log("le modal est ici");
    Shiny.setInputValue(arg.id_note, arg.note_initial_value);
    Shiny.setInputValue(arg.id_format, arg.format_initial_value);
    Shiny.setInputValue(arg.id_etat, arg.etat_initial_value);
  }

  waitForEl(
    "#" + arg.modalToWaitFor, () => {
      setDefaultValuesWhenModalShows();

      setInputValuesWhenValueChanges(arg.id_note);
      setInputValuesWhenValueChanges(arg.id_format);
      setInputValuesWhenValueChanges(arg.id_etat);

    }
  );
});
