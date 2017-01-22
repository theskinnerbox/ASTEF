<template>
    <div>
        <div class="row">
            <div class="col-md-12">
                <per-minute-fixations-chart></per-minute-fixations-chart>
            </div>
        </div>

        <div class="row" v-show="showWidget">
            <div class="col-md-3">
                <button class="btn btn-info form-control" v-on:click="previousPage" :disabled="currentMinute == 0">&lt;&lt; Previous</button>
            </div>
            <div class="col-md-6">
                <p style="text-align: center; padding-top: 8px;">
                    Minute: <b>{{ currentMinute + 1 }}</b>
                </p>
            </div>
            <div class="col-md-3">
                <button class="btn btn-info form-control" v-on:click="nextPage" :disabled="currentMinute == minutesCount - 1">Next &gt;&gt;</button>
            </div>
        </div>

        <div class="row" v-show="showWidget" style="margin-top: 10px;">
            <input style="display:none;" type="file" name="bg-image" id="bg-image" accept="image/*" v-model="bgImage" v-on:change="changeBackground" />

            <div class="col-md-6">
                <button class="btn btn-info form-control" v-on:click="openBackgroundSelectDialog">Load Background Image</button>
            </div>

            <div class="col-md-6">
                <button class="btn btn-info form-control" v-on:click="removeBackgroundImage">Remove Background Image</button>
            </div>
        </div>
    </div>
</template>
<style>
</style>
<script>
    import PerMinuteFixationsChart from './PerMinuteFixationsChart.vue';

    export default {
        data() {
            return {
                chartResolution: {},
                fixationsData: [],

                currentMinute: 0,
                minutesCount: 0,

                bgImage: '',

                showWidget: false
            }
        },
        methods: {
            nextPage: function () {
                this.currentMinute++;
                this.refreshChart();
                this.$dispatch('change-minute', this.currentMinute);
            },
            previousPage: function () {
                this.currentMinute--;
                this.refreshChart();
                this.$dispatch('change-minute', this.currentMinute);
            },
            resetPaginator: function () {
                this.currentMinute = 0;
                this.minutesCount = this.fixationsData.length;
                this.$dispatch('change-minute', this.currentMinute);
            },
            refreshChart() {
                this.$broadcast('render-minute-chart', {
                    fixationPoints: this.fixationsData[this.currentMinute].points,
                    resolution: this.chartResolution
                });
            },
            openBackgroundSelectDialog: function() {
                document.getElementById("bg-image").click();
            },
            changeBackground: function() {
                this.$broadcast('change-background', '');

                let file = document.getElementById("bg-image").files[0],
                        url = window.URL || window.webkitURL,
                        src = url.createObjectURL(file);

                this.$broadcast('change-background', src);
            },
            removeBackgroundImage: function() {
                if(this.bgImage == '') {
                    alert('Please chose a background image first.');
                    return;
                }

                this.bgImage = '';
                this.$broadcast('change-background', '');
            }
        },
        components: {
            'per-minute-fixations-chart': PerMinuteFixationsChart
        },
        events: {
            'render': function (eventData) {
                this.showWidget = true;
                this.fixationsData = eventData.fixationsData;
                this.chartResolution = eventData.resolution;

                this.resetPaginator();
                this.refreshChart();
            },
            'reset': function () {
                this.showWidget = false;
                return true;
            },
            'change-minute': function (minute) {
                this.currentMinute = minute;
                this.refreshChart();
            }
        }
    }
</script>
