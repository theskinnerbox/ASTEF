<template>
  <div class="container">
    <h1>Test!</h1>
    <p>{{ msg }}</p>
    <p><input type="text" class="form-control" v-model="msg" /></p>
  </div>
</template>

<script>
export default {
  data () {
    return {
      msg: 'Hello from vue-loader!'
    }
  }
}
</script>

<style>
</style>
