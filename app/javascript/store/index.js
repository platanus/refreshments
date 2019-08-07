import Vue from 'vue/dist/vue.esm.js';
import Vuex from 'vuex';

import { shuffle } from 'lodash';

import productApi from '../api/products';
import invoiceApi from '../api/invoices';
import statisticsApi from '../api/statistics';

const REFRESH_INTERVAL_TIME = 300000;

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    showResume: false,
    products: {},
    invoice: {},
    status: false,
    loading: false,
    actionMessage: '',
    actionProductId: null,
    intervalId: null,
    gif: null,
    feeBalance: 0,
  },
  mutations: {
    setProduct: (state, payload) => {
      Object.assign(state.products[payload.id], payload);
    },
    setActionMessage: (state, payload) => {
      state.actionMessage = payload;
    },
    setActionProduct: (state, payload) => {
      state.actionProductId = payload;
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
    },
    setIntervalId: (state, payload) => {
      state.intervalId = payload;
    },
    setGif: (state, payload) => {
      state.gif = payload;
    },
    setFeeBalance: (state, payload) => {
      state.feeBalance = payload;
    },
  },
  actions: {
    getProducts: context => {
      productApi.products().then((response) => {
        const products = response.products.reduce((acc, product) => {
          acc[product.id] = { ...product, amount: 0 };

          return acc;
        }, {});
        context.commit('setProducts', products);
        context.dispatch('startGetProductsInterval');
      });
    },
    decrementProduct: (context, payload) => {
      const amount = payload.amount - 1 > 0 ? payload.amount - 1 : 0;
      context.commit('setActionProduct', payload.id);
      context.commit('setActionMessage', 'decrement');
      context.commit('setProduct', { ...payload, amount });
      context.dispatch('startGetProductsInterval');
      context.dispatch('buy');
    },
    incrementProduct: (context, payload) => {
      if (payload.amount === 0) {
        context.dispatch('updateProduct', payload);
      }
      context.commit('setActionProduct', payload.id);
      if (payload.stock > payload.amount) {
        context.commit('setProduct', { ...payload, amount: payload.amount + 1 });
        context.commit('setActionMessage', 'increment');
        context.dispatch('stopGetProductsInterval');
        context.dispatch('buy');
      } else {
        context.commit('setActionMessage', 'maxStock');
      }
    },
    updateProduct: (context, payload) => {
      productApi.product(payload.id).then((response) => {
        context.commit('setProduct', response.product);
      });
    },
    buy: context => {
      if (context.getters.totalAmount) {
        const cartProducts = context.getters.cartProducts;

        context.commit('setLoading', true);

        invoiceApi.buy(cartProducts).then((response) => {
          context.commit('setInvoice', response.invoice);
          context.commit('setLoading', false);
        });
      } else {
        context.commit('setLoading', false);
        context.commit('setInvoice', {});
      }
    },
    toggleResume: context => {
      context.commit('toggleResume');
    },
    cleanCart: context => {
      context.getters.productsAsArray.forEach(product => {
        context.commit('setProduct', { ...product, amount: 0 });
      });
      context.commit('setLoading', false);
      context.dispatch('startGetProductsInterval');
    },
    cleanInvoice: context => {
      context.commit('setInvoice', {});
      context.commit('setStatus', false);
    },
    updateInvoiceSettled: context => {
      invoiceApi.checkInvoiceStatus(context.state.invoice.rHash).then((response) => {
        context.commit('setInvoiceSettled', response.settled);
      });
    },
    testInvoice: context => {
      context.commit('setInvoiceSettled', true);
    },
    setLoading: (context, payload) => {
      context.commit('setLoading', payload);
    },
    startGetProductsInterval: context => {
      if (context.getters.totalAmount === 0 && !context.state.intervalId) {
        const interval = setInterval(() => {
          context.dispatch('getProducts');
        }, REFRESH_INTERVAL_TIME);
        context.commit('setIntervalId', interval);
      }
    },
    stopGetProductsInterval: context => {
      if (context.state.intervalId) {
        clearInterval(context.state.intervalId);
        context.commit('setIntervalId', null);
      }
    },
    getGif: context => {
      invoiceApi.getGif().then((response) => {
        context.commit('setGif', response.gifUrl.gifUrl);
      });
    },
    getFeeBalance: context => {
      statisticsApi.feeBalance().then((response) => {
        context.commit('setFeeBalance', response.feeBalance);
      });
    },
  },
  getters: {
    productsAsArray: state => (Object.keys(state.products).map(key => ({ id: key, ...state.products[key] }))),
    onSaleProducts: (state, getters) => (
      getters.productsAsArray.filter(product => product.forSale)
    ),
    sortRandom: (state, getters) => (
      shuffle(getters.onSaleProducts)
    ),
    sortByFee: (state, getters) => (
      getters.sortRandom.sort((a, b) => b.feeRate - a.feeRate)
    ),
    groupByCategory: (state, getters) => keyword => (
      getters.sortByFee.filter(product => product.category === keyword)
    ),
    totalAmount: (state, getters) => (
      getters.onSaleProducts.reduce((acc, product) => acc + product.amount, 0)
    ),
    totalPrice: (state, getters) => (
      getters.onSaleProducts.reduce((acc, product) => acc + product.price * product.amount, 0)
    ),
    cartProducts: (state, getters) => {
      const products = getters.productsAsArray.reduce((acc, product) => {
        if (product.amount > 0) {
          acc[product.id] = {
            amount: product.amount,
          };
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
    },
  },
});

export default store;
