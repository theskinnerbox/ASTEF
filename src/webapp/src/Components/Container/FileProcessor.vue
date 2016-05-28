<template>
    <div class="row">
        <div class="col-md-7"></div>
        <div class="col-md-5"></div>
    </div>
</template>

<script>
    import FixationsDataProcessor from '../../Processors/FixationsDataProcessor'

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
            }
        },
        components: {},
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
