Shiny.addCustomMessageHandler('waitForButtons', function (arg) {

  var waitForEl = function (selector, callback) {
    if (jQuery(selector).length) {
      callback();
    } else {
      setTimeout(function () {
        waitForEl(selector, callback);
      }, 100);
    }
  };

  var setInputValueAfterClick = function (button1, button2) {
    $(document).on('click', button1, () => {
      Shiny.setInputValue(arg.shinyinput, "TRUE", { priority: "event" })
    })
    $(document).on('click', button2, () => {
      Shiny.setInputValue(arg.shinyinput, "FALSE", { priority: "event" })
    })
  }

  waitForEl(
    "#" + arg.buttonToWaitFor1, () => {
      setInputValueAfterClick("#" + arg.buttonToWaitFor1, "#" + arg.buttonToWaitFor2)
    }
  );
});
