<template>
  <div class="resume">
    <div class="resume__container">
      <h3 class="resume__title">Tu Compra</h3>
      <div class="resume__erase">
        <font-awesome-icon icon="trash-alt" @click="cleanKart(); cleanInvoice();" />
      </div>

      <div class="resume__product-list" key="products">
        <div class="resume__product resume__product--title">
          <div class="resume-product__price">#</div>
          <div class="resume-product__name">Producto</div>
          <div class="resume-product__total">Precio</div>
        </div>
        <v-touch v-for="product in products" class="resume__product" :product="product" v-if="product.amount > 0" v-on:swipeleft="decrementProduct(product)" v-on:swiperight="incrementProduct(product)">
          <div class="resume-product__price">{{ product.amount }}</div>
          <div class="resume-product__name">{{ product.name }}</div>
          <div class="resume-product__total">$ {{ product.price }}</div>
        </v-touch>
      </div>
      <div class="resume-total">
        <span class="resume-total__title">Total</span>
        <span class="resume-total__value">${{ totalPrice }}</span>
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
        'decrementProduct',
        'incrementProduct',
        'cleanKart',
        'cleanInvoice'
      ]),
    }
  }
</script>
