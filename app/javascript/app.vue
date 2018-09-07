<template>
  <div>
    <div class="header">
      <img class="header__logo" src="~/assets/images/platanus_logo.svg">
    </div>
    <div class="app">
      <qrcode value="lntb147130n1pdexq0xpp5ll527tm2n7sva7lntwurmmant55av3p73n8q04exc2u0d36akwksdqs23jhxapqwfskjmrncqzys0pq6j7rpzemr8l4nw0k7hnrexhxyjslaeg9ekhszvdnfn6qmug79hvulfych20cjzxffdvl238sjrzl0hl8n8md7apt2wpn5xt8s3hsq69k6em" :options="{ size: 200 }"></qrcode>
      <h2>Productos</h2>
      <div class="product-list" key="products">
        <product v-for="product in products" :product="product"></product>
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex';

  import product from './components/product.vue';

  export default {
    components: {
      product,
    },
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
