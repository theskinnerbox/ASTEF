<template>
    <div class="container">
        <h1>ASTEF Web Application</h1>
        <p><b>A Simple Tool for Examining Fixations. (<a href="http://astef.info">http://astef.info</a>)</b></p>

        <hr />

        <div class="row">
            <file-loader></file-loader>
        </div>
  </div>
</template>

<script>
    import FileLoader from './Container/FileLoader.vue'

    export default {
        data () {
            return {}
        },
        components: {
            'file-loader': FileLoader
        },
        events: {
            'reset': function() {
                this.$broadcast('reset');
            }
        }
    }
</script>

<style>
</style>
