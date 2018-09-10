<template>
  <div class="product-list__product" >
    <div class="product__image">
      <img :src="product.image_url">
      <div class="product__manager" v-if="product.amount > 0">
        <span class="product-manager__minus" @click="decrementProduct(product)">
          <font-awesome-icon icon="minus" v-if="product.amount > 1" />
          <font-awesome-icon icon="trash-alt" v-else />
        </span>
        <span class="product-manager__value">{{ product.amount }}</span>
        <span class="product-manager__plus" @click="incrementProduct(product)">
          <font-awesome-icon icon="plus" />
        </span>
      </div>
      <div class="product__add" v-else  @click="incrementProduct(product)">
        Agregar
      </div>
    </div>
    <span class="product__price">$ {{ product.price }}</span>
    <span class="product__name">{{ product.name }}</span>
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
        'incrementProduct'
      ])
    }
  }
</script>
