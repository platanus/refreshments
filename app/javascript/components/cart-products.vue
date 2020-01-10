<template>
  <div
    class="debt-product-list"
  >
    <div class="debt-product-list__title">
      <div class="debt-product-list__amount">#</div>
      <div class="debt-product-list__name">Producto</div>
      <div class="debt-product-list__total">Precio</div>
    </div>
    <div
      v-for="product in cartProducts"
      :key="product.id"
      class="debt-product-list__info"
      :product="product"
    >
      <div class="debt-product-list__amount">{{ product.amount }}</div>
      <div class="debt-product-list__name">{{ product.name }}</div>
      <div class="debt-product-list__total">$ {{ product.price }}</div>
    </div>
    <div class="debt-total">
      <div class="debt-total__title">Total (SAT)</div>
      <div class="debt-total__void-cell"/>
      <div
        class="debt-total__value"
        :class="{ 'debt-total__value--loading': loading}"
      >
        S {{ invoice.amount || 0 }}
      </div>
    </div>
  </div>
</template>

<script>

import { mapState, mapGetters } from 'vuex';

export default {
  data() {
    return {};
  },
  computed: {
    ...mapState([
      'loading',
      'invoice',
    ]),
    ...mapGetters({
      'products': 'productsAsArray',
      'totalAmount': 'totalAmount',
      'totalPrice': 'totalPrice',
      'totalFee': 'totalFee',
    }),
    cartProducts() {
      return this.products.filter(product => product.amount > 0);
    },
  },
  mounted() {

  },
};
</script>
