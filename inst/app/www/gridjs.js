$(document).ready(function () {
  Shiny.addCustomMessageHandler('build_grid', function (arg) {
    new gridjs.Grid({
      columns: arg.columns,
      search: true,
      data: arg.data,
      pagination: {
        limit: 5,
        summary: false
      }
    }).render(document.getElementById(arg.id));
  })

  Shiny.addCustomMessageHandler('build_gridpochtml', function (arg) {
    new gridjs.Grid({
      columns: [
        "Species",
        {
          name: 'ht',
          formatter: (cell) => gridjs.html(`${cell}`)
        }
      ],
      search: true,
      data: arg.data,
      pagination: {
        limit: 5,
        summary: false
      }
    }).render(document.getElementById(arg.id));
  })
  // });

  Shiny.addCustomMessageHandler('build_gridpochtml2', function (arg) {
    new gridjs.Grid({
      columns: [
        "titre",
        "date_publication",
        "nb_pages",
        "editeur",
        "possede",
        "note",
        "type_publication",
        "statut",
        {
          name: 'lien_cover',
          formatter: (cell) => gridjs.html(`${cell}`)
        },
        "ISBN"
      ],
      search: true,
      data: arg.data,
      pagination: {
        limit: 5,
        summary: false
      }
    }).render(document.getElementById(arg.id));
  })
});