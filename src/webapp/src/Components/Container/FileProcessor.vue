<template>
    <div class="row">
        <div class="col-md-7"></div>
        <div class="col-md-5">
            <nni-history-chart></nni-history-chart>
        </div>
    </div>
</template>

<script>
    import FixationsDataProcessor from '../../Processors/FixationsDataProcessor'

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

                this.$broadcast('render-history', this.fixationsData);
            }
        },
        components: {
            'nni-history-chart': NNIHistoryChart
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
