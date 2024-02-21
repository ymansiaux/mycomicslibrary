$(document).ready(function () {
  Shiny.addCustomMessageHandler('call_sweetalert2', function (arg) {

    if (arg.type == "error") {
      Swal.fire({
        icon: "error",
        title: "Oups...",
        text: arg.msg
      });
    }

    if (arg.type == "success") {
      Swal.fire({
        icon: "success",
        title: "Succès",
        text: arg.msg
      });
    }

    if (arg.type == "autoclose") {
      let timerInterval;
      Swal.fire({
        title: arg.msg,
        html: "",
        timer: 2000,
        timerProgressBar: true,
        didOpen: () => {
          Swal.showLoading();
          const timer = Swal.getPopup().querySelector("b");
          timerInterval = setInterval(() => {
            timer.textContent = `${Swal.getTimerLeft()}`;
          }, 100);
        },
        willClose: () => {
          clearInterval(timerInterval);
        }
      }).then((result) => {
        /* Read more about handling dismissals below */
        if (result.dismiss === Swal.DismissReason.timer) {
          console.log("I was closed by the timer");
        }

      });
    }
  });


  Shiny.addCustomMessageHandler('modal_result_detect_isbn', function (arg) {
    Swal.fire({
      title: arg.msg,
      icon: "success",
      html: `Vous pouvez ajouter cet ISBN au menu de recherche`,
      showDenyButton: false,
      showCancelButton: true,
      confirmButtonText: "Ajouter l'ISBN",
      cancelButtonText: `Quitter`
    }).then((result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire("ISBN ajouté !", "", "success");
        Shiny.setInputValue(arg.id, result.isConfirmed, {
          priority: "event"
        });
      } else {
        Swal.fire("Résultat non conservé", "", "info");
      }
    });
  });



  Shiny.addCustomMessageHandler('modal_api_search_result', function (arg) {

    Swal.fire({
      title: "Livre identifié",
      icon: "success",
      html: arg.html,
      showDenyButton: true,
      showCancelButton: true,
      confirmButtonText: "Ajouter le livre à ma bibliothèque",
      denyButtonText: `Ajouter à ma liste d'envies`,
      cancelButtonText: `Quitter`
    }).then((result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire("Le livre va être ajouté à la bibliothèque !", "", "info");
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "TRUE", {
          priority: "event"
        });
      } else if (result.isDenied) {
        Swal.fire("Le livre va être ajouté à la liste d'envies !", "", "info");
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "FALSE", {
          priority: "event"
        });
      } else if (result.isDismissed) {
        Swal.fire("Livre non enregistré", "", "info");
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "", {
          priority: "event"
        });
      }
    });
  });

  //9782756061832
  Shiny.addCustomMessageHandler('modal_modify_book_in_collection', function (arg) {
    Swal.fire({
      title: `Modifier les informations du livre`,
      icon: "info",
      html: arg.html,
      showDenyButton: false,
      showCancelButton: true,
      confirmButtonText: "Modifier le livre",
      cancelButtonText: `Quitter`
    }).then((result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire("Livre modifié !", "", "success");
        Shiny.setInputValue(arg.id_valider_modification, result.isConfirmed, {
          priority: "event"
        });
      } else {
        Swal.fire("Modification non réalisée", "", "info");
      }
    });
  });

  Shiny.addCustomMessageHandler('modal_delete_book_in_collection', function (arg) {
    Swal.fire({
      title: "Êtes-vous sûr de vouloir supprimer ce livre ?",
      text: "Vous ne pourrez pas revenir en arrière !",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Oui, supprimer !",
      cancelButtonText: "Annuler"
    }).then((result) => {
      if (result.isConfirmed) {
        Shiny.setInputValue(arg.id_valider_suppression, result.isConfirmed, {
          priority: "event"
        });
      }
    });
  });




});