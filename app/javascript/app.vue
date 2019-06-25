<template>
  <div>
    <feedback
      v-show="status"
      @close="closeModal"
    />
    <div class="messages">
      <flash-message transition-name="list-complete" />
    </div>
    <div class="app">
      <div
        class="product-list"
        key="products"
      >
        <product
          v-for="product in sortedProductList"
          :key="product.id"
          :product="product"
        />
      </div>
      <div class="sidebar">
        <div class="sidebar__container">
          <app-resume />
          <app-invoice />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex';

import appResume from './components/app-resume.vue';
import appInvoice from './components/app-invoice.vue';
import product from './components/product.vue';
import feedback from './components/feedback.vue';

export default {
  components: {
    appResume,
    appInvoice,
    product,
    feedback,
  },
  computed: {
    ...mapGetters({
      'products': 'productsAsArray',
      'totalAmount': 'totalAmount',
    }),
    ...mapState([
      'status',
    ]),
    sortedProductList() {
      return [...this.products].sort((a, b) => a.name.localeCompare(b.name));
    },
  },
  methods: {
    closeModal() {
      this.$store.commit('setStatus', false);
    },
  },
  mounted() {
    this.$store.dispatch('getProducts');
  },
};
</script>
