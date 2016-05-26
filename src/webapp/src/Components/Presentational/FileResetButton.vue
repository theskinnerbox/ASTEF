<template>
    <div class="col-md-4">
        <p>
            <button class="btn btn-default form-control" v-on:click="reset">Reset</button>
        </p>
    </div>
</template>

<style>
</style>

<script>
    export default{
        data(){
            return{}
        },
        methods: {
            reset: function () {
                if(confirm('Are you sure that you want to reset all?')) {
                    this.$dispatch('reset');
                }
            }
        }
    }
</script>
