$(document).ready(function () {
  Shiny.addCustomMessageHandler("call_sweetalert2", function (arg) {
    if (arg.type == "error") {
      Swal.fire({
        icon: "error",
        title: "Oups...",
        text: arg.msg,
      });
    } else if (arg.type == "success") {
      Swal.fire({
        icon: "success",
        title: "Success",
        text: arg.msg,
      });
    } else if (arg.type == "info") {
      Swal.fire({
        icon: "info",
        title: "Info",
        text: arg.msg,
      });
    } else if (arg.type == "warning") {
      Swal.fire({
        icon: "warning",
        title: "Warning",
        html: arg.msg,
      });
    } else if (arg.type == "autoclose") {
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
        },
      }).then((result) => {
        /* Read more about handling dismissals below */
        if (result.dismiss === Swal.DismissReason.timer) {
          console.log("I was closed by the timer");
        }
      });
    }
  });
  
    Shiny.addCustomMessageHandler("call_sweetalert2_with_html", function (arg) {
    if (arg.type == "error") {
      Swal.fire({
        icon: "error",
        title: "Oups...",
        html:arg.html
      });
    } else if (arg.type == "success") {
      Swal.fire({
        icon: "success",
        title: "Success",
        html:arg.html
      });
    } else if (arg.type == "info") {
      Swal.fire({
        icon: "info",
        title: "Hi folks !",
        html:arg.html
      });
    } else if (arg.type == "warning") {
      Swal.fire({
        icon: "warning",
        title: "Warning",
        html:arg.html
      });
    }
  });

  Shiny.addCustomMessageHandler("modal_result_detect_isbn", function (arg) {
    Swal.fire({
      title: arg.msg,
      icon: "success",
      html: `You can start a search with this ISBN`,
      showDenyButton: false,
      showCancelButton: true,
      confirmButtonText: "Search book",
      cancelButtonText: `Quit`,
      returnFocus: false,
    }).then((result) => {
      if (result.isConfirmed) {
        Shiny.setInputValue(arg.id, result.isConfirmed, {
          priority: "event",
        });
        Shiny.setInputValue(arg.id_trigger, Math.random(), {
          priority: "event",
        });
      } else {
        Swal.fire("Result dismissed", "", "info");
      }
    });
  });

  Shiny.addCustomMessageHandler("modal_api_search_result", function (arg) {
    Swal.fire({
      title: "Book found",
      icon: "success",
      html: arg.html,
      showDenyButton: true,
      showCancelButton: true,
      confirmButtonText: "Add to collection",
      denyButtonText: "Add to wishlist",
      cancelButtonText: "Cancel",
    }).then((result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire(
          "The book is going to be added to your library !",
          "",
          "info"
        );
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "TRUE", {
          priority: "event",
        });
      } else if (result.isDenied) {
        Swal.fire(
          "The book is going to be added to your wishlist !",
          "",
          "info"
        );
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "FALSE", {
          priority: "event",
        });
      } else if (result.isDismissed) {
        Swal.fire("Book dismissed", "", "info");
        Shiny.setInputValue(arg.id_ajout_bibliotheque, "", {
          priority: "event",
        });
      }
    });
  });

  Shiny.addCustomMessageHandler(
    "modal_modify_book_in_collection",
    function (arg) {
      Swal.fire({
        title: `Modify the book characteristics`,
        icon: "info",
        html: arg.html,
        showDenyButton: false,
        showCancelButton: true,
        confirmButtonText: "Edit the book",
        cancelButtonText: `Quit`,
      }).then((result) => {
        /* Read more about isConfirmed, isDenied below */
        if (result.isConfirmed) {
          Swal.fire("Book edited !", "", "success");
          Shiny.setInputValue(arg.id_valider_modification, result.isConfirmed, {
            priority: "event",
          });
        } else {
          Swal.fire("Book modifications dismissed", "", "info");
        }
      });
    }
  );

  Shiny.addCustomMessageHandler("modal_2_choices", function (arg) {
    Swal.fire({
      title: arg.title,
      text: arg.text,
      icon: arg.icon,
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: arg.confirmButtonText,
      cancelButtonText: arg.cancelButtonText,
    }).then((result) => {
      if (result.isConfirmed) {
        Shiny.setInputValue(arg.id_resultat_modal, result.isConfirmed, {
          priority: "event",
        });
      }
    });
  });
});
