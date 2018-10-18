<template>
  <v-touch class="product-list__product"
           v-on:swipeleft="decrementProduct(product); message('decrement', product)"
           v-on:swiperight="incrementProduct(product); message('increment', product)">
    <img class="product__image" :src="product.image_url"
         @click="incrementProduct(product); message('increment', product)">
  </v-touch>
</template>
<script>
  import { mapActions } from 'vuex';
  import utils from '../utils/';

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
      message(action, product) {
        const content = utils.contentMessage(action, product);

        if (content.length > 0) {
          this.flash(content, 'success');
        }
      }
    }
  }
</script>
