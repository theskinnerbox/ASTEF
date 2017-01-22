<template>
    <div>
        <canvas id="nni-history-chart" width="400" height="300"></canvas>
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
            render: function (nniValues) {
                let minutes = [], c = 1;
                for(let i in nniValues) {
                    minutes.push(c);
                    c++;
                }

                let context = document.getElementById("nni-history-chart");
                this.chart = new Chart(context, {
                    type: 'line',
                    data: {
                        labels: minutes,
                        datasets: [{
                            label: 'Nearest Neighbor Index',
                            fill: false,
                            lineTension: 0.1,
                            backgroundColor: "rgba(75,192,192,0.4)",
                            borderColor: "rgba(75,192,192,1)",
                            borderCapStyle: 'butt',
                            borderDash: [],
                            borderDashOffset: 0.0,
                            borderJoinStyle: 'miter',
                            pointBorderColor: "rgba(75,192,192,1)",
                            pointBackgroundColor: "#fff",
                            pointBorderWidth: 1,
                            pointHoverRadius: 5,
                            pointHoverBackgroundColor: "rgba(75,192,192,1)",
                            pointHoverBorderColor: "rgba(220,220,220,1)",
                            pointHoverBorderWidth: 2,
                            pointRadius: 3,
                            pointHitRadius: 10,
                            borderWidth: 1,
                            data: nniValues
                        }]
                    },
                    options: {
                        responsive: true,
                        title: {
                            display: true,
                            text: 'Nearest Neighbor Index'
                        },
                        legend: {
                            display: false
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero:true,
                                    max: 1
                                }
                            }],
                            xAxes: [{
                                ticks: {
                                    maxRotation: 0
                                }
                            }]
                        },
                        tooltips: {
                            callbacks: {
                                title: function (tooltipItem, data) {
                                    let label = data.labels[tooltipItem[0].index];
                                    return 'Minute: ' + label;
                                }
                            }
                        }
                    }
                });

                let that = this;
                context.onclick = function(evt){
                    let activePoints = that.chart.getElementsAtEvent(evt);
                    if(activePoints[0] != undefined) {
                        that.$dispatch('change-minute', activePoints[0]._index);
                    }
                };

                this.highlightMinute(0);
            },
            highlightMinute: function(currentMinute) {
                if(this.chart !== null) {

                    let pointBackgroundColors = [];
                    let pointRadius = [];

                    for(let c = 0; c < this.chart.data.datasets[0].data.length; c++) {
                        if(c == currentMinute) {
                            pointRadius.push(5);
                            pointBackgroundColors.push('rgba(75,192,192,1)');
                        } else {
                            pointRadius.push(3);
                            pointBackgroundColors.push('#FFFFFF');
                        }
                    }

                    this.chart.data.datasets[0].pointBackgroundColor = pointBackgroundColors;
                    this.chart.data.datasets[0].pointRadius = pointRadius;
                    this.chart.update();
                }
            }
        },
        events: {
            'render': function (eventData) {
                let nniValues = [];
                for(let c in eventData.fixationsData) {
                    nniValues.push(eventData.fixationsData[c].nni.nni[0].toFixed(5));
                }

                this.render(nniValues);
            },
            'reset': function () {
                this.chart.destroy();
            },
            'change-minute': function(currentMinute) {
                this.highlightMinute(currentMinute);
            }
        }
    }
</script>

<style>
</style>
