<template>
    <div>
        <canvas id="per-minute-fixations-chart" width="1024" height="768"></canvas>
    </div>
</template>

<script>
    import Chart from 'chart.js'

    export default {
        data() {
            return {
                chart: null
            }
        },
        methods: {
            render: function (fixationPoints) {
                if(this.chart != null) {
                    this.chart.destroy();
                }

                let points = [];
                for(let c in fixationPoints) {
                    points.push({
                        x: fixationPoints[c][0],
                        y: fixationPoints[c][1]
                    });
                }

                let context = document.getElementById("per-minute-fixations-chart");
                this.chart =  new Chart(context, {
                    type: 'line',
                    data: {
                        datasets: [{
                            label: 'Fixations',
                            fill: false,
                            lineTension: 0,
                            borderColor: "rgba(255,99,132,1)",
                            borderWidth: 1,
                            pointBorderColor: "rgba(255,99,132,1)",
                            pointBackgroundColor: "rgba(255, 99, 132, 0.2)",
                            pointBorderWidth: 1,
                            pointRadius: 5,

                            data: points
                        }]
                    },
                    options: {
                        scales: {
                            xAxes: [{
                                type: 'linear',
                                position: 'bottom',
                                ticks: {
                                    beginAtZero: true,
                                    max: 1024
                                }
                            }],
                            yAxes: [{
                                ticks: {
                                    reverse: true,
                                    beginAtZero: true,
                                    max: 768
                                }
                            }]
                        },
                        tooltips: {
                            callbacks: {
                                title: function () {
                                    return '';
                                },
                                label: function (tooltipItem, data) {
                                    return 'X: ' + tooltipItem.xLabel + ' - Y: ' + tooltipItem.yLabel;
                                }
                            }
                        }
                    }
                });
            }
        },
        events: {
            'render-minute-chart': function (fixationPoints) {
                this.render(fixationPoints);
            },
            'reset': function () {
                this.chart.destroy();
            }
        }
    }
</script>

<style>
</style>
