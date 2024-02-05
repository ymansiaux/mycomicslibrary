$(document).ready(function () {
  Shiny.addCustomMessageHandler('quagga', function (arg) {

    console.log(arg.src);

    Quagga.decodeSingle({
      decoder: {
        readers: ["ean_reader"] // List of active readers
      },
      locate: true, // try to locate the barcode in the image
      src: arg.src
    }, function (result) {
      if (result.codeResult) {
        console.log("result", result.codeResult.code);
        Shiny.setInputValue("detected_barcode_quagga", result.codeResult.code);
      } else {
        console.log("not detected");
        Shiny.setInputValue("detected_barcode_quagga", "0");
      }
    });
  });
});
