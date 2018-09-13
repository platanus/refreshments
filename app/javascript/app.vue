<template>
  <div>
    <div class="header">
      <img class="header__logo" src="~/assets/images/platanus_logo.svg">
      <div class="header__basket">
        <font-awesome-layers class="fa-fw fa-2x">
          <font-awesome-icon far icon="shopping-basket"></font-awesome-icon>
          <font-awesome-layers class="fa-layers-counter fa-layers-top-right">{{ totalAmount }}</font-awesome-layers>
        </font-awesome-layers>
      </div>
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
  import { mapGetters, mapActions } from 'vuex';

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
        'totalAmount': 'totalAmount',
      })
    },
    mounted() {
      this.$store.dispatch('getProducts');
    }
  }
</script>
