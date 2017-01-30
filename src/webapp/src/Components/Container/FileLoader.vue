<template>
    <div>
        <div class="row">
            <file-input></file-input>
            <file-reset-button></file-reset-button>
        </div>

        <file-loading-spinner></file-loading-spinner>

        <hr />
    </div>
</template>

<style>
</style>

<script>
    import FileInput from '../Presentational/FileInput.vue'
    import FileResetButton from '../Presentational/FileResetButton.vue'
    import FileLoadingSpinner from '../Presentational/FileLoadingSpinner.vue'

    import FixationsFileValidator from '../../Validators/FixationsFileValidator'

    export default{
        data(){
            return {}
        },
        components:{
            'file-input': FileInput,
            'file-reset-button': FileResetButton,
            'file-loading-spinner': FileLoadingSpinner
        },
        methods: {
            loadFixationsFile: function (fileObject) {
                this.$broadcast('fixations-file-loading');

                let fileReader = new FileReader();

                let that = this;
                fileReader.onload = function () {
                    let fixationsFileValidator = new FixationsFileValidator();
                    let fileContentsAsArray = fileReader.result.split("\n");

                    if(fixationsFileValidator.validate(fileContentsAsArray)){
                        fileContentsAsArray.pop();

                        that.$broadcast('fixations-file-loaded');
                        that.$dispatch('valid-file-loaded', fileContentsAsArray);
                    } else {
                        alert('The file you have provided has a wrong format. Please check it.');
                        that.$dispatch('reset');
                    }
                };

                fileReader.readAsText(fileObject);
            }
        },
        events: {
            'load-fixations-file': function(fileObject) {
                this.loadFixationsFile(fileObject);
            }
        }
    }
</script>
