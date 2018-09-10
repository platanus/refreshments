import Vue from 'vue';
import Vuex from 'vuex';

import api from './api';

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    products: {},
  },
  mutations: {
    setProduct: (state, payload) => {
      Object.assign(state.products[payload.id], payload);
    },
    setProducts: (state, payload) => {
      state.products = payload;
    },
  },
  actions: {
    getProducts: context => {
      api.products().then((response) => {
        const products = response.products.reduce((acc, product) => {
          acc[product.id] = { ...product, amount: 0 };
          return acc;
        }, {});
        context.commit('setProducts', products);
      });
    },
    decrementProduct: (context, payload) => {
      const amount = payload.amount - 1 > 0 ? payload.amount - 1 : 0;
      context.commit('setProduct', { ...payload, amount: amount });
    },
    incrementProduct: (context, payload) => {
      context.commit('setProduct', { ...payload, amount: payload.amount + 1 });
    },
    buy: context => {
      const products = context.getters.productsAsArray.reduce((acc, product) => {
        if (product.amount > 0) {
          acc[product.id] = product.amount;
        }

        return acc;
      }, {});
      api.buy(products).then()
    }
  },
  getters: {
    productsAsArray: state => (Object.keys(state.products).map(key => ({ id: key, ...state.products[key] }))),
  },
});

export default store;
