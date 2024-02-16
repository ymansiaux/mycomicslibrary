$(document).ready(function () {
  Shiny.addCustomMessageHandler('build_grid', function (arg) {
    new gridjs.Grid({
      columns: [
        "Species",
        {
          name: 'ht',
          formatter: (cell) => gridjs.html(`${cell}`)
        }
      ],
      search: true,
      data: arg.data
      // data: Array(5).fill().map(x => [
      //   "12",
      //   "<h1> coucou </h1>"
      // ])
    }).render(document.getElementById(arg.id));
  })
});