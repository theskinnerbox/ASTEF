<template>
    <div class="row">
        <div class="col-md-7">
            <per-minute-widget></per-minute-widget>
        </div>
        <div class="col-md-5">
            <nni-history-widget></nni-history-widget>
        </div>
    </div>
</template>

<script>
    import FixationsDataProcessor from '../../Processors/FixationsDataProcessor'

    import PerMinuteWidget from '../Presentational/PerMinuteWidget.vue'
    import NNIHistoryWidget from '../Presentational/NNIHistoryWidget.vue'

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
                let screenResolution = fixationsDataProcessor.getScreenResolution(this.fileContentsAsArray);
                this.fixationsData = fixationsDataProcessor.process(this.fileContentsAsArray);

                this.$broadcast('render', {
                    resolution: screenResolution,
                    fixationsData: this.fixationsData
                });
            }
        },
        components: {
            'nni-history-widget': NNIHistoryWidget,
            'per-minute-widget': PerMinuteWidget
        },
        events: {
            'process': function (fileContentsAsArray) {
                this.fileContentsAsArray = fileContentsAsArray;
                this.process();
            },
            'change-minute': function (minute) {
                this.$broadcast('change-minute', minute);
            }
        }
    }
</script>

<style>
</style>
