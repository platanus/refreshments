/* eslint no-console: 0 */

import Vue from 'vue';
import App from '../app.vue';

import store from '../store';

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('app') !== null) {
    const el = document.getElementById('app');

    return new Vue({
      el,
      store,
      render: h => h(App),
    });
  }
})
