<template>
    <div class="row">
        <div class="col-md-12" v-if="isLoading" style="margin-top: 50px;">
            <p style="text-align: center;">
                <img src="../../../assets/images/ring.gif" />
            </p>
            <p style="text-align: center; margin-top: 20px;">Loading the Fixations File, Wait...</p>
        </div>
    </div>
</template>

<style>
</style>

<script>
    export default{
        data(){
            return{
                isLoading: false
            }
        },
        methods: {
            hideSpinner: function () {
                this.isLoading = false;
            }
        },
        events: {
            'fixations-file-loading': function () {
                this.isLoading = true;
            },
            'fixations-file-loaded': function () {
                this.hideSpinner();
            },
            'reset': function () {
                this.hideSpinner();
            }
        }
    }
</script>
