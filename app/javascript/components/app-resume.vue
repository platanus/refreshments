<template>
  <div class="resume">
    <div class="resume__container">
      <h3 class="resume__title">Tu Compra</h3>
      <img
        class="resume__logo"
        src="~/assets/images/platanus_logo.svg"
      >

      <div class="resume__erase">
        <font-awesome-icon
          icon="trash-alt"
          @click="cleanKart(); cleanInvoice();"
        />
      </div>

      <div
        class="resume__product-list"
        key="products"
      >
        <div class="resume__product resume__product--title">
          <div class="resume-product__price">#</div>
          <div class="resume-product__name">Producto</div>
          <div class="resume-product__total">Precio</div>
        </div>
        <v-touch
          v-for="product in cartProducts"
          :key="product.id"
          class="resume__product"
          :product="product"
          @swipeleft="decrementProduct(product);"
          @swiperight="incrementProduct(product);"
        >
          <div class="resume-product__price">{{ product.amount }}</div>
          <div class="resume-product__name">{{ product.name }}</div>
          <div class="resume-product__total">$ {{ userProductPrice(product) }}</div>
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
import utils from '../utils/';

export default {
  data() {
    return {};
  },
  computed: {
    ...mapState([
      'showResume',
      'invoice',
    ]),
    ...mapGetters({
      'products': 'productsAsArray',
      'totalAmount': 'totalAmount',
      'totalPrice': 'totalPrice',
    }),
    cartProducts() {
      return this.products.filter(product => product.amount > 0);
    },
  },
  methods: {
    ...mapActions([
      'toggleResume',
      'decrementProduct',
      'incrementProduct',
      'cleanKart',
      'cleanInvoice',
    ]),
    message(action, product) {
      const content = utils.contentMessage(action, product);

      if (content.length > 0) {
        this.flash(content, 'success');
      }
    },
    userProductPrice(product) {
      const sortedList = [...product.user_products].sort((a, b) => (a.price - b.price));

      return sortedList[0].price;
    },
  },
};
</script>
