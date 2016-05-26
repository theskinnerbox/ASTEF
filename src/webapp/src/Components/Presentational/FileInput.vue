<template>
    <div class="col-md-8">
        <p>
            <input type="file" class="form-control" placeholder="Choose a Fixation File..." v-on:change="handleFileChange"  v-model="fileName" />
        </p>
    </div>
</template>

<style>
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
