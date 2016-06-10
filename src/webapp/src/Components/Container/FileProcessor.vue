<template>
    <div class="row">
        <div class="col-md-7">
            <per-minute-widget></per-minute-widget>
        </div>
        <div class="col-md-5">
            <nni-history-chart></nni-history-chart>
        </div>
    </div>
</template>

<script>
    import FixationsDataProcessor from '../../Processors/FixationsDataProcessor'

    import PerMinuteWidget from '../Presentational/PerMinuteWidget.vue'
    import NNIHistoryChart from '../Presentational/NNIHistoryChart.vue'

    export default{
        data(){
            return {
                fixationsData: [],
                fileContentsAsArray: []
            }
        },
        methods: {
            process: function () {
                this.gatherFixationsData();
            },
            gatherFixationsData: function () {
                let fixationsDataProcessor = new FixationsDataProcessor();
                this.fixationsData = fixationsDataProcessor.process(this.fileContentsAsArray);

                this.$broadcast('render', this.fixationsData);
            }
        },
        components: {
            'nni-history-chart': NNIHistoryChart,
            'per-minute-widget': PerMinuteWidget
        },
        events: {
            'process': function (fileContentsAsArray) {
                this.fileContentsAsArray = fileContentsAsArray;
                this.process();
            }
        }
    }
</script>

<style>
</style>
