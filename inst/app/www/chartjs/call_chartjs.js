$(document).ready(function () {
  Shiny.addCustomMessageHandler("call_chartjs", function (arg) {
    console.log(arg);
    const ctx = document.getElementById(arg.id);

    const chart = Chart.getChart(arg.id);

    if (chart == undefined) {
      console.log("Creating a new chart");
      new Chart(ctx, {
        type: "bar",
        data: {
          labels: arg.labels,
          datasets: [
            {
              label: arg.label,
              data: arg.data,
              borderWidth: 1,
              backgroundColor: [
                  /*  'rgba(255, 99, 132, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(255, 205, 86, 0.7)',
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(153, 102, 255, 0.7)',*/
                    "#851495",
                    "#ee689f",
                    "#290fe5",
                    "#0a55a4",
                    "#6eeec6",
                    "#1cbf6d",
                    "#7b9f07",
                    "#a1c722"
                    
                ]
            },
          ],
        },
        options: {
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                stepSize:1
              }
            },
          },
        },
      });
    } else {
      console.log("Updating an existing chart");
      chart.data.labels = arg.labels;
      chart.data.datasets[0].label = arg.label;
      chart.data.datasets[0].data = arg.data;
      chart.update();
    }
  });
});