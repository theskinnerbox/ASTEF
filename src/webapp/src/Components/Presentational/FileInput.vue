<template>
    <div class="col-md-8">
        <p>
            <input type="file" class="form-control" placeholder="Choose a Fixation File..." v-on:change="handleFileChange"  v-model="fileName" />
        </p>
        <p class="small input-info">Use this control to upload a fixations file. <a href="sample.txt" target="_blank">Need a sample to play?</a></p>
    </div>
</template>

<style>
    .input-info {
        margin-bottom: 0px;
        padding-left: 10px;
    }
</style>

<script>
    export default{
        data(){
            return {
                fileName: ''
            }
        },
        methods: {
            handleFileChange: function (event) {
                this.$dispatch('load-fixations-file', event.target.files[0]);
            }
        },
        events: {
            'reset': function() {
                this.fileName = '';
            }
        }
    }
</script>
