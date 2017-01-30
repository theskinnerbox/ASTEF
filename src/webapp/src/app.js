// stylesheets
require('../node_modules/bootstrap/dist/css/bootstrap.min.css');
require('../node_modules/bootstrap/dist/css/bootstrap-theme.min.css');

// scripts
import Vue from 'vue'
import VueStrap from 'vue-strap'
import App from './Components/App.vue'

new Vue({
    el: 'body',
    components: { App }
});
