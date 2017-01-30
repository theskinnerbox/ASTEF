<template>
    <div class="row">
        <div class="col-md-12">
            <nni-history-chart></nni-history-chart>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <time-series-saver></time-series-saver>
        </div>
    </div>
</template>

<script>
    import NNIHistoryChart from './NNIHistoryChart.vue'
    import TimeSeriesSaver from '../Container/TimeSeriesSaver.vue'

    export default {
        data(){
            return {}
        },
        components: {
            'nni-history-chart': NNIHistoryChart,
            'time-series-saver': TimeSeriesSaver
        }
    }
</script>

<style>
</style>
