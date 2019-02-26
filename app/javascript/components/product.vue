<template>
  <v-touch class="product-list__product" @tap="incrementProduct(product); message('increment', product)">
    <img class="product__image" :src="product.image_url">
    <span class="product__price">${{product.price}}</span>
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
