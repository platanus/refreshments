<template>
  <div>
    <div class="header">
      <img class="header__logo" src="~/assets/images/platanus_logo.svg">
    </div>
    <div class="app">
      <h2>Productos</h2>
      <div class="product-list" key="products">
        <div class="product-list__product" v-for="product in products">
          <img class="product__image" :src="product.image_url">
          <span class="product__price">$ {{ product.price }}</span>
          <span class="product__name">{{ product.name }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    data: function () {
      return {}
    },
    computed: {
      ...mapState([
        'products'
      ])
    },
    mounted() {
      this.$store.dispatch('getProducts');
    }
  }
</script>
