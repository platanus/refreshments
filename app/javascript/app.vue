<template>
  <div>
    <app-header></app-header>
    <div class="app">
      <h2>Productos</h2>
      <div class="product-list" key="products">
        <product v-for="product in products" :product="product"></product>
      </div>
    </div>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex';

  import appHeader from './components/app-header.vue';
  import product from './components/product.vue';

  export default {
    components: {
      appHeader,
      product,
    },
    data: function () {
      return {}
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
