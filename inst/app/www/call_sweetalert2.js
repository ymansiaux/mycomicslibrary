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
  })
});
