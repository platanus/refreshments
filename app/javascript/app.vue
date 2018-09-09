<template>
  <div>
    <div class="header">
      <img class="header__logo" src="~/assets/images/platanus_logo.svg">
    </div>
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

  import product from './components/product.vue';

  export default {
    components: {
      product,
    },
    data: function () {
      return {}
    },
    computed: {
      ...mapGetters({
        'products': 'productsAsArray',
      })
    },
    mounted() {
      this.$store.dispatch('getProducts');
    }
  }
</script>
