<template>
    <div class="row">
        <div class="col-md-12 time-series-saver">
            <button v-show="showButton"  v-on:click="dispatchSave" class="btn btn-success"><i class="glyphicon glyphicon-save"></i> Save Time Series</button>
        </div>
    </div>
</template>

<script>
    export default{
        data(){
            return {
                showButton: false
            }
        },
        methods: {
            dispatchSave: function () {
                this.$dispatch('save-time-series');
            }
        },
        components: {},
        events: {
            'render': function () {
                this.showButton = true;
            },
            'reset': function () {
                this.showButton = false;
            }
        }
    }
</script>

<style>
    .time-series-saver {
        text-align: center;
        padding-top: 15px;
    }
</style>
