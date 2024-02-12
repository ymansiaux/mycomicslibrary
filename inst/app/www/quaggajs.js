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
        Shiny.setInputValue(arg.id, "No barcode detected");
        Shiny.setInputValue(arg.quagga_has_finished, Math.random());
        return;
      }
      if (result.codeResult) {
        console.log("result", result.codeResult.code);
        Shiny.setInputValue(arg.id, result.codeResult.code);
        Shiny.setInputValue(arg.quagga_has_finished, Math.random());
      } else {
        console.log("not detected");
        Shiny.setInputValue(arg.id, "No barcode detected");
        Shiny.setInputValue(arg.quagga_has_finished, Math.random());
      }
    });
  });
});
