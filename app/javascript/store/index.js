import Vue from 'vue';
import Vuex from 'vuex';

import api from './api';

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    products: [],
  },
  mutations: {
    setProducts: (state, payload) => {
      state.products = payload;
    },
  },
  actions: {
    getProducts: context => {
      api.products().then((response) => {
        context.commit('setProducts', response.products);
      });
    },
  },
  getters: {},
});

export default store;
