import Vue from 'vue/dist/vue.esm.js';
import Vuex from 'vuex';

import { shuffle } from 'lodash';

import productApi from '../api/products';
import invoiceApi from '../api/invoices';
import statisticsApi from '../api/statistics';

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
    gif: null,
    feeBalance: 0,
    shuffled: false,
    shuffledIndexes: {},
  },
  mutations: {
    setProduct: (state, payload) => {
      Object.assign(state.products[payload.id], payload);
    },
    addProduct: (state, payload) => {
      state.products = Object.assign({}, state.products, payload);
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
    setGif: (state, payload) => {
      state.gif = payload;
    },
    setFeeBalance: (state, payload) => {
      state.feeBalance = payload;
    },
    setShuffled: (state, payload) => {
      state.shuffled = payload;
    },
    setShuffledIndexes: (state, payload) => {
      state.shuffledIndexes = payload;
    },
  },
  actions: {
    addProduct: (context, payload) => {
      const prod = {};
      prod[payload.id] = { ...payload, amount: prod[payload.id].amount };
      context.commit('addProduct', prod);
    },
    getProducts: context => {
      productApi.products().then((response) => {
        const products = response.products.reduce((acc, product) => {
          acc[product.id] = { ...product, amount: 0 };

          return acc;
        }, {});
        context.commit('setProducts', products);
        context.dispatch('cleanInvoice');
        if (!context.state.shuffled) {
          context.dispatch('shuffleIndexes');
        }
      });
    },
    shuffleIndexes: context => {
      const shuffledIndexes = shuffle(context.state.products).map(product => product.id);
      context.commit('setShuffledIndexes', shuffledIndexes);
      context.commit('setShuffled', true);
    },
    decrementProduct: (context, payload) => {
      const amount = payload.amount - 1 > 0 ? payload.amount - 1 : 0;
      context.commit('setActionProduct', payload.id);
      context.commit('setActionMessage', 'decrement');
      context.commit('setProduct', { ...payload, amount });
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
    refreshProducts: context => {
      context.commit('setShuffled', false);
      context.dispatch('getProducts');
    },
  },
  getters: {
    productsAsArray: state => Object.values(state.products),
    onSaleProducts: (state, getters) => (
      getters.productsAsArray.filter(product => product.forSale)
    ),
    sortRandom: (state, getters) => {
      if (state.shuffled) {
        return getters.restorePreviousOrder;
      }

      return shuffle(getters.onSaleProducts);
    },
    restorePreviousOrder: (state, getters) => {
      const previousOrder = state.shuffledIndexes;
      const reOrderedProducts = getters.onSaleProducts.sort(
        (a, b) => previousOrder.indexOf(a.id) - previousOrder.indexOf(b.id)
      );

      return reOrderedProducts;
    },
    sortByFee: (state, getters) => (
      getters.sortRandom.sort((a, b) => b.feeRate - a.feeRate)
    ),
    groupByCategory: (state, getters) => keyword => (
      getters.sortByFee.filter(product => product.category === keyword)
    ),
    totalAmount: (state, getters) => (
      getters.onSaleProducts.reduce((acc, product) => acc + product.amount, 0)
    ),
    totalFee: (state, getters) => {
      const { clp, amount } = state.invoice;
      const satoshiValue = amount && clp ? amount / clp : 0;

      const totalClp = getters.productsAsArray.reduce((acc, product) => {
        const actualFee = product.feeRate * product.price * product.amount;

        return Math.round(acc + actualFee);
      }, 0);

      return {
        clp: totalClp,
        sat: Math.round(totalClp * satoshiValue),
      };
    },
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
