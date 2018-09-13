<template>
  <div>
    <app-header></app-header>
    <div class="app">
      <h2>Productos</h2>
      <div class="product-list" key="products">
        <product v-for="product in products" :product="product"></product>
      </div>
    </div>
    <app-resume></app-resume>
    <app-invoice></app-invoice>
  </div>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex';

  import appHeader from './components/app-header.vue';
  import appResume from './components/app-resume.vue';
  import appInvoice from './components/app-invoice.vue';
  import product from './components/product.vue';

  export default {
    components: {
      appHeader,
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
