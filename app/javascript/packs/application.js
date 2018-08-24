/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm';
import App from '../app.vue';

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('app') !== null) {
    const el = document.getElementById('app');

    return new Vue({
      el,
      render: h => h(App),
    });
  }
})
