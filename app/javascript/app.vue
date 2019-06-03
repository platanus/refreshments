<template>
  <div>
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
import { mapGetters } from 'vuex';

import appResume from './components/app-resume.vue';
import appInvoice from './components/app-invoice.vue';
import product from './components/product.vue';

export default {
  components: {
    appResume,
    appInvoice,
    product,
  },
  computed: {
    ...mapGetters({
      'products': 'productsAsArray',
      'totalAmount': 'totalAmount',
    }),
    sortedProductList() {
      return [...this.products].sort((a, b) => a.name.localeCompare(b.name));
    },
  },
  mounted() {
    this.$store.dispatch('getProducts');
  },
};
</script>
