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
        {
          name: 'note',
          formatter: (cell) => gridjs.html(`${cell}`)
        },
        "type_publication",
        "statut",
        {
          name: 'lien_cover',
          formatter: (cell) => gridjs.html(`<a target="_blank" href='${cell}'>Couverture</a>`)
        },
        "ISBN",
        {
          name: 'modify_properties_buttons',
          formatter: (cell) => gridjs.html(`${cell}`)
        },
        {
          name: 'delete_book_buttons',
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
});