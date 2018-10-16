<template>
  <v-touch class="product-list__product" v-on:swipeleft="decrementProduct(product)" v-on:swiperight="incrementProduct(product)">
    <img class="product__image" :src="product.image_url"  @click="incrementProduct(product)">
  </v-touch>
</template>
<script>
  import { mapActions } from 'vuex';

  export default {
    props: ['product'],
    data: function () {
      return {}
    },
    computed: {},
    methods: {
      ...mapActions([
        'decrementProduct',
        'incrementProduct',
      ]),
    }
  }
</script>
