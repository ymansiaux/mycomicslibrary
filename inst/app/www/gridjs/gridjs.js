$(document).ready(function () {

  Shiny.addCustomMessageHandler('build_my_collection', function (arg) {
    console.log("gridjs");

    // var gridIsAlreadyHere = ($("#130_poc_gridjs_1-my_collection").length) > 0;

    // console.log(gridIsAlreadyHere);
    // https://stackoverflow.com/questions/68263328/how-do-you-add-or-replace-the-data-in-grid-js-once-it-has-been-rendered


    const mygrid = new gridjs.Grid({
      columns: [
        "titre",
        {
          name: 'publication',
          attributes: {
            'data-field': 'annee_publication'
          }
        },
        {
          name: 'nb pages',
          attributes: {
            'data-field': 'nb_pages'
          }
        },
        "auteur",
        "editeur",
        {
          name: 'note',
          formatter: (cell) => gridjs.html(`${cell}`)
        },
        {
          name: 'format',
          attributes: {
            'data-field': 'type_publication'
          }
        },
        {
          name: 'etat',
          attributes: {
            'data-field': 'statut'
          }
        },
        {
          name: 'couverture',
          attributes: {
            'data-field': 'lien_cover'
          },
          formatter: (cell) => gridjs.html(`<a target="_blank" href='${cell}'>Clic</a>`)
        },
        "ISBN",
        {
          name: 'Modifier',
          attributes: {
            'data-field': 'modify_properties_buttons'
          },
          formatter: (cell) => gridjs.html(`${cell}`)
        },
        {
          name: 'Supprimer',
          attributes: {
            'data-field': 'delete_book_buttons'
          },
          formatter: (cell) => gridjs.html(`${cell}`)
        }
      ],
      search: true,
      data: arg.data,
      pagination: {
        limit: 5,
        summary: true
      },
      language: {
        'search': {
          'placeholder': '🔍 Rechercher...'
        },
        'pagination': {
          'previous': 'Précédent',
          'next': 'Suivant',
          'showing': '😃 Affichage',
          'to': 'à',
          'of': 'parmi',
          'results': () => 'résultats'
        }
      },
      style: {
        table: {
          border: '3px solid #ccc'
        },
        th: {
          'background-color': 'rgba(0, 0, 0, 0.1)',
          color: '#000',
          'border-bottom': '3px solid #ccc',
          'text-align': 'center'
        },
        td: {
          'text-align': 'center',
          color: '#000',
          'border-bottom': '3px solid #ccc',
          'text-align': 'center'
        }
      }
    }).render(document.getElementById(arg.id));

  })
});