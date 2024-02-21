$(document).ready(function () {
  Shiny.addCustomMessageHandler('call_chartjs', function (arg) {
    const ctx = document.getElementById(arg.id);

    let chartStatus = Chart.getChart(arg.id);
    if (chartStatus != undefined) {
      chartStatus.destroy();
    }
    const myLineChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: arg.labels,
        datasets: [{
          label: arg.label,
          data: arg.data,
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          x: {
            display: false,
            grid: {
              display: false,
            }
          },
          y: {
            display: false,
            grid: {
              display: false
            }
          }
        }
      }
    });
  })
});
