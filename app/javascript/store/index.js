import Vue from 'vue';
import Vuex from 'vuex';

import api from './api';

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    showResume: false,
    products: {},
    invoice: {},
    status: false,
  },
  mutations: {
    setProduct: (state, payload) => {
      Object.assign(state.products[payload.id], payload);
    },
    setProducts: (state, payload) => {
      state.products = payload;
    },
    toggleResume: state => {
      state.showResume = !state.showResume;
    },
    setInvoice: (state, payload) => {
      state.invoice = payload;
    },
    setStatus: (state, payload) => {
      state.status = payload;
    },
    setInvoiceSettled: (state, payload) => {
      state.invoice.settled = payload;
      state.status = payload;
    }
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
      context.dispatch('buy');
    },
    buy: context => {
      const products = context.getters.productsAsArray.reduce((acc, product) => {
        if (product.amount > 0) {
          acc[product.id] = product.amount;
        }

        return acc;
      }, {});
      api.buy(products).then((response) => {
        context.commit('setInvoice', response.invoice);
      });
    },
    toggleResume: context => {
      context.commit('toggleResume');
    },
    cleanKart: context => {
      context.getters.productsAsArray.forEach(product => {
        context.commit('setProduct', { ...product, amount: 0 });
      });
    },
    cleanInvoice: context => {
      context.commit('setInvoice', {});
      context.commit('setStatus', false);
    },
    updateInvoiceSettled: context => {
      api.checkInvoiceStatus(context.state.invoice.r_hash).then((response) => {
        context.commit('setInvoiceSettled', response.data.settled);
      });
    },
    testInvoice: context => {
      context.commit('setInvoiceSettled', true);
    }
  },
  getters: {
    productsAsArray: state => (Object.keys(state.products).map(key => ({ id: key, ...state.products[key] }))),
    totalAmount: (state, getters) => (
      getters.productsAsArray.reduce((acc, product) => acc += product.amount, 0)
    ),
    totalPrice: (state, getters) => (
      getters.productsAsArray.reduce((acc, product) => acc += (product.price * product.amount), 0)
    ),
  },
});

export default store;
