/* eslint no-console: 0 */
/* global document */

import Vue from 'vue';
import { library } from '@fortawesome/fontawesome-svg-core';
import { faMinus, faPlus, faTrashAlt, faShoppingBasket, faTimes } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon, FontAwesomeLayers, FontAwesomeLayersText } from '@fortawesome/vue-fontawesome';

import App from '../app.vue';
import store from '../store';

library.add(faMinus, faPlus, faTrashAlt, faShoppingBasket, faTimes);

document.addEventListener('DOMContentLoaded', () => {
  Vue.component('font-awesome-icon', FontAwesomeIcon);
  Vue.component('font-awesome-layers', FontAwesomeLayers);
  Vue.component('font-awesome-layers-text', FontAwesomeLayersText);

  Vue.config.productionTip = false;

  if (document.getElementById('app') !== null) {
    const el = document.getElementById('app');

    return new Vue({
      el,
      store,
      render: h => h(App),
    });
  }

  return '';
});
