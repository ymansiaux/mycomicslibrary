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
    Shiny.setInputValue(arg.id_annee_publication, arg.annee_publication_initial_value);
    Shiny.setInputValue(arg.id_nb_pages, arg.nb_pages_initial_value);
    Shiny.setInputValue(arg.id_auteur, arg.auteur_initial_value);
    Shiny.setInputValue(arg.id_editeur, arg.editeur_initial_value);
  }

  waitForEl(
    "#" + arg.modalToWaitFor, () => {
      setDefaultValuesWhenModalShows();

      setInputValuesWhenValueChanges(arg.id_note);
      setInputValuesWhenValueChanges(arg.id_format);
      setInputValuesWhenValueChanges(arg.id_etat);
      setInputValuesWhenValueChanges(arg.id_annee_publication);
      setInputValuesWhenValueChanges(arg.id_nb_pages);
      setInputValuesWhenValueChanges(arg.id_auteur);
      setInputValuesWhenValueChanges(arg.id_editeur);

    }
  );
});
