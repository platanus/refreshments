/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm';
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  console.log("jejejej")
  if (document.getElementById('app') !== null) {
    new Vue({ el: '#app' }); // eslint-disable-line no-new
  }
})
