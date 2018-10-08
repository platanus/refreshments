<template>
  <div class="product-list__product" >
    <img class="product__image" :src="product.image_url"  @click="incrementProduct(product)">
  </div>
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
        'toggleResume',
      ]),
    }
  }
</script>
