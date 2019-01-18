import Vue from 'vue/dist/vue.esm.js';
import Vuex from 'vuex';

import api from './api';

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    showResume: false,
    products: {},
    invoice: {},
    status: false,
    loading: 0,
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
    },
    setLoading: (state, payload) => {
      state.loading = payload;
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
      context.dispatch('buy');
    },
    incrementProduct: (context, payload) => {
      context.commit('setProduct', { ...payload, amount: payload.amount + 1 });
      context.dispatch('buy');
    },
    buy: context => {
      if (context.getters.totalAmount) {
        const products = context.getters.buyProducts;
        const description = context.getters.buyDescription;

        context.commit('setLoading', 1);
        api.buy(products, description).then((response) => {
          context.commit('setInvoice', response.invoice);
          context.commit('setLoading', -1);
        });
      } else {
        context.commit('setInvoice', {});
      }
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
    },
    setLoading: (context, payload) => {
      const value = context.state.loading + payload;
      context.commit('setLoading', value > 0 ? value : 0);
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
    buyProducts: (state, getters) => {
      const products = getters.productsAsArray.reduce((acc, product) => {
        if (product.amount > 0) {
          acc[product.id] = {
            amount: product.amount,
            price: product.price,
          }
        }

        return acc;
      }, {});

      return products;
    },
    buyDescription: (state, getters) => {
      const description = [];
      getters.productsAsArray.forEach(product => {
        if (product.amount > 0) {
          description.push(`${product.amount} x ${product.name}`);
        }
      });

      return description.join(',\n');
    }
  },
});

export default store;
