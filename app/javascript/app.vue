<template>
  <div>
    <div class="app">
      <div class="product-list" key="products">
        <product v-for="product in products" :product="product"></product>
      </div>
      <app-resume></app-resume>
    </div>
    <app-invoice></app-invoice>
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
    data: function () {
      return {};
    },
    computed: {
      ...mapGetters({
        'products': 'productsAsArray',
        'totalAmount': 'totalAmount',
      })
    },
    mounted() {
      this.$store.dispatch('getProducts');
    }
  }
</script>
