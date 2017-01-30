<template>
    <div class="container">
        <h1>ASTEF Web Application</h1>
        <p><b>A Simple Tool for Examining Fixations. (<a href="http://astef.info">http://astef.info</a>)</b></p>

        <hr />

        <file-loader></file-loader>
        <file-processor></file-processor>
  </div>
</template>

<script>
    import FileLoader from './Container/FileLoader.vue'
    import FileProcessor from './Container/FileProcessor.vue'

    export default {
        data () {
            return {}
        },
        components: {
            'file-loader': FileLoader,
            'file-processor': FileProcessor
        },
        events: {
            'reset': function() {
                this.$broadcast('reset');
            },
            'valid-file-loaded': function (fileContentsAsArray) {
                this.$broadcast('process', fileContentsAsArray);
            }
        }
    }
</script>

<style>
</style>
