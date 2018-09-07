<template>
  <div class="product-list__product" >
    <img class="product__image" :src="product.image_url">
    <span class="product__price">$ {{ product.price }}</span>
    <span class="product__name">{{ product.name }}</span>
  </div>
</template>
<script>
  import { mapState, mapGetters, mapActions } from 'vuex'
  export default {
    props: ['product'],
    data: function () {
      return {}
    },
    computed: {},
    methods: {}
  }
</script>
