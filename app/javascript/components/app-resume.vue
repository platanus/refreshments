<template>
  <div class="resume">
    <div class="resume__container">
      <h3 class="resume__title">Tu Compra</h3>
      <div class="resume__product-list" key="products">
        <div class="resume__product resume__product--title">
          <div class="resume-product__price">#</div>
          <div class="resume-product__name">Producto</div>
          <div class="resume-product__total">Precio</div>
        </div>
        <div v-for="product in products" class="resume__product" :product="product" v-if="product.amount > 0">
          <div class="resume-product__price">{{ product.amount }}</div>
          <div class="resume-product__name">{{ product.name }}</div>
          <div class="resume-product__total">$ {{ product.price }}</div>
        </div>
      </div>
      <div class="resume-total">
        <span class="resume-total__title">Total</span>
        <span class="resume-total__value">${{ totalPrice }}</span>
      </div>
      <div class="resume__actions">
        <div class="btn" @click="buy">
          Comprar
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import { mapState, mapGetters, mapActions } from 'vuex';

  export default {
    data: function () {
      return {}
    },
    computed: {
      ...mapState([
        'showResume',
        'invoice'
      ]),
      ...mapGetters({
        'products': 'productsAsArray',
        'totalAmount': 'totalAmount',
        'totalPrice': 'totalPrice',
      }),
    },
    methods: {
      ...mapActions([
        'toggleResume',
        'buy'
      ]),
    }
  }
</script>
