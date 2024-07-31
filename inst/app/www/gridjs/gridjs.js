var mygrid_collection;
var mygrid_wishlist;

$(document).ready(function () {
  Shiny.addCustomMessageHandler("build_my_collection", function (arg) {
    if (mygrid_collection == undefined) {
      mygrid_collection = new gridjs.Grid({
        columns: [
          {
            name: "title",
            attributes: {
              "data-field": "titre",
            },
          },
          {
            name: "publication",
            attributes: {
              "data-field": "annee_publication",
            },
          },
          {
            name: "nb pages",
            attributes: {
              "data-field": "nb_pages",
            },
          },
          {
            name: "author",
            attributes: {
              "data-field": "auteur",
            },
          },
          {
            name: "editor",
            attributes: {
              "data-field": "editeur",
            },
          },
          {
            name: "rating",
            attributes: {
              "data-field": "note",
            },
            formatter: (cell) => gridjs.html(`${cell}`),
          },
          {
            name: "format",
            attributes: {
              "data-field": "type_publication",
            },
          },
          {
            name: "condition",
            attributes: {
              "data-field": "statut",
            },
          },
          {
            name: "cover",
            attributes: {
              "data-field": "lien_cover",
            },
            formatter: (cell) =>
              gridjs.html(
                `<a class = "btn btn-primary"  target="_blank" href='${cell}'>Clic</a>`
              ),
          },
          "ISBN",
          {
            name: "Modify",
            attributes: {
              "data-field": "modify_properties_buttons",
            },
            formatter: (cell) => gridjs.html(`${cell}`),
          },
          {
            name: "Delete",
            attributes: {
              "data-field": "delete_book_buttons",
            },
            formatter: (cell) => gridjs.html(`${cell}`),
          },
        ],
        search: true,
        data: arg.data,
        pagination: {
          limit: 5,
          summary: true,
        },
        language: {
          search: {
            placeholder: "🔍 Search...",
          },
          pagination: {
            previous: "Previous",
            next: "Next",
            showing: "😃 Displaying",
            to: "to",
            of: "among",
            results: () => "results",
          },
        },
        style: {
          table: {
            border: "3px solid #ccc",
          },
          th: {
            "background-color": "rgba(0, 0, 0, 0.1)",
            color: "#000",
            "border-bottom": "3px solid #ccc",
            "text-align": "center",
          },
          td: {
            "text-align": "center",
            color: "#000",
            "border-bottom": "3px solid #ccc",
            "text-align": "center",
          },
        },
      }).render(document.getElementById(arg.id));
    } else {
      mygrid_collection
        .updateConfig({
          data: arg.data,
        })
        .forceRender();
    }
  });

  Shiny.addCustomMessageHandler("build_my_wishlist", function (arg) {
    if (mygrid_wishlist == undefined) {
      mygrid_wishlist = new gridjs.Grid({
        columns: [
          {
            name: "title",
            attributes: {
              "data-field": "titre",
            },
          },
          {
            name: "publication",
            attributes: {
              "data-field": "annee_publication",
            },
          },
          {
            name: "nb pages",
            attributes: {
              "data-field": "nb_pages",
            },
          },
          {
            name: "author",
            attributes: {
              "data-field": "auteur",
            },
          },
          {
            name: "editor",
            attributes: {
              "data-field": "editeur",
            },
          },
          {
            name: "cover",
            attributes: {
              "data-field": "lien_cover",
            },
            formatter: (cell) =>
              gridjs.html(
                `<a class = "btn btn-primary" target="_blank" href='${cell}'>Clic</a>`
              ),
          },
          "ISBN",
          {
            name: "Add to collection",
            attributes: {
              "data-field": "add_to_collection_buttons",
            },
            formatter: (cell) => gridjs.html(`${cell}`),
          },
          {
            name: "Delete",
            attributes: {
              "data-field": "delete_book_buttons",
            },
            formatter: (cell) => gridjs.html(`${cell}`),
          },
        ],
        search: true,
        data: arg.data,
        pagination: {
          limit: 5,
          summary: true,
        },
        language: {
          search: {
            placeholder: "🔍 Rechercher...",
          },
          pagination: {
            previous: "Previous",
            next: "Next",
            showing: "😃 Displaying",
            to: "to",
            of: "among",
            results: () => "results",
          },
        },
        style: {
          table: {
            border: "3px solid #ccc",
          },
          th: {
            "background-color": "rgba(0, 0, 0, 0.1)",
            color: "#000",
            "border-bottom": "3px solid #ccc",
            "text-align": "center",
          },
          td: {
            "text-align": "center",
            color: "#000",
            "border-bottom": "3px solid #ccc",
            "text-align": "center",
          },
        },
      }).render(document.getElementById(arg.id));
    } else {
      mygrid_wishlist
        .updateConfig({
          data: arg.data,
        })
        .forceRender();
    }
  });
});
