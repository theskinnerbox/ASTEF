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
                    Minute: <b>{{ currentMinute }}</b>
                </p>
            </div>
            <div class="col-md-3">
                <button class="btn btn-info form-control" v-on:click="nextPage" :disabled="currentMinute == minutesCount - 1">Next &gt;&gt;</button>
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
                fixationsData: [],

                currentMinute: 0,
                minutesCount: 0,

                showWidget: false
            }
        },
        methods: {
            nextPage: function () {
                this.currentMinute++;
                this.refreshChart();
            },
            previousPage: function () {
                this.currentMinute--;
                this.refreshChart();
            },
            resetPaginator: function () {
                this.currentMinute = 0;
                this.minutesCount = this.fixationsData.length;
            },
            refreshChart() {
                this.$broadcast('render-minute-chart', this.fixationsData[this.currentMinute].points);
            }
        },
        components: {
            'per-minute-fixations-chart': PerMinuteFixationsChart
        },
        events: {
            'render': function (fixationsData) {
                this.showWidget = true;
                this.fixationsData = fixationsData;

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
