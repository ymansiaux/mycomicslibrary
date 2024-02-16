$(document).ready(function () {
  Shiny.addCustomMessageHandler('build_grid', function (arg) {
    new gridjs.Grid({
      columns: arg.columns,
      search: true,
      data: arg.data
    }).render(document.getElementById(arg.id));
  })
});