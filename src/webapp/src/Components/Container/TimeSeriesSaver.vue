<template>
    <time-series-saver-button></time-series-saver-button>
</template>

<script>
    import FileSaver from 'file-saver'
    import TimeSeriesSaverButton from '../Presentational/TimeSeriesSaverButton.vue'

    export default {
        data(){
            return {
                processedData: {}
            }
        },
        components:{
            'time-series-saver-button': TimeSeriesSaverButton
        },
        methods: {
            saveTimeSeries: function () {
                let fileContents = [
                    "Minute ID | NNI convex hull Donnelly \n"
                ];

                for(let c in this.processedData) {
                    fileContents.push((parseInt(c) + 1).toString() + " " + this.processedData[c]['nni']['nni'][1].toFixed(5) + "\n");
                }

                let file = new File(fileContents, "fix-nni.txt", {type: "text/plain;charset=utf-8"});
                FileSaver.saveAs(file);
            }
        },
        events: {
            'save-time-series': function () {
                this.saveTimeSeries();
            },
            'render': function (eventData) {
                this.processedData = eventData.fixationsData;
                return true;
            },
            'reset': function () {
                this.processedData = {};
                return true;
            }
        }
    }
</script>

<style>
</style>
