$(document).ready(function () {
  Shiny.addCustomMessageHandler('quagga', function (arg) {

    Quagga.decodeSingle({
      decoder: {
        readers: ["ean_reader"] // List of active readers
      },
      locate: true, // try to locate the barcode in the image
      src: arg.src
    }, function (result) {
      if (!result) {
        console.log("Error");
        Shiny.setInputValue(arg.id, "");
        Shiny.setInputValue(arg.quagga_has_finished, Math.random());
        return;
      }
      if (result.codeResult) {
        console.log("result", result.codeResult.code);
        Shiny.setInputValue(arg.id, result.codeResult.code);
        Shiny.setInputValue(arg.quagga_has_finished, Math.random());
      } else {
        console.log("not detected");
        Shiny.setInputValue(arg.id, "");
        Shiny.setInputValue(arg.quagga_has_finished, Math.random());
      }
    });
  });
});

// r_call : 
// golem::invoke_js(
//   "quagga",
//   message = list(
//     src = r_local$last_picture,
//     id = ns("detected_barcode_quagga"),
//     quagga_has_finished = ns("quagga_has_finished")
//   )
// )