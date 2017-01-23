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
            render: function (fixationPoints, resolution) {
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
                        title: {
                            display: true,
                            text: 'Scanpath'
                        },
                        legend: {
                            display: false
                        },
                        scales: {
                            xAxes: [{
                                type: 'linear',
                                position: 'bottom',
                                ticks: {
                                    beginAtZero: true,
                                    max: resolution.width
                                }
                            }],
                            yAxes: [{
                                ticks: {
                                    reverse: true,
                                    beginAtZero: true,
                                    max: resolution.height
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
            },
            handleResize: function() {
                if(this.bgImage !== '') {
                    let canvas = document.getElementById('per-minute-fixations-chart');
                    canvas.style.backgroundSize = 'auto ' + (canvas.height - 60) + 'px';
                }
            }
        },
        ready: function () {
            window.addEventListener('resize', this.handleResize);
        },
        beforeDestroy: function () {
            window.removeEventListener('resize', this.handleResize);
        },
        events: {
            'render-minute-chart': function (eventData) {
                this.render(eventData.fixationPoints, eventData.resolution);
            },
            'reset': function () {
                this.chart.destroy();
            },
            'change-background': function(src) {
                let canvas = document.getElementById('per-minute-fixations-chart');

                if(src === '') {
                    canvas.style.backgroundImage = '';
                    return;
                }

                canvas.style.backgroundImage = 'url(\'' + src + '\')';
                canvas.style.backgroundPositionX = '40px';
                canvas.style.backgroundPositionY = '32px';
                canvas.style.backgroundRepeat = 'no-repeat';
                canvas.style.backgroundSize = 'auto ' + (canvas.height - 60) + 'px';
            }
        }
    }
</script>

<style>
</style>
