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
        Shiny.setInputValue(arg.id_ajout_bibliotheque, true, {
          priority: "event"
        });
      } else if (result.isDenied) {
        Swal.fire("Le livre va être ajouté à la liste d'envies !", "", "info");
        Shiny.setInputValue(arg.id_ajout_bibliotheque, false, {
          priority: "event"
        });
      } else {
        Swal.fire("Livre non enregistré", "", "info");
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "", {
          priority: "event"
        });
      }
    });


  });

});