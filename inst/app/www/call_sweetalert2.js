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
  })
});
