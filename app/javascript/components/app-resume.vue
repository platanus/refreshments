<template>
  <transition name="slide-fade">
  <div class="resume" v-if="showResume">
    <div class="resume__container">
      <div class="resume__close" @click="toggleResume">
        <font-awesome-icon far icon="times"></font-awesome-icon>
      </div>
      <h3>Tu Orden</h3>
      <div class="resume__product-list" key="products">
        <div v-for="product in products" class="resume__product" :product="product" v-if="product.amount > 0">
          <div class="resume-product__image"><img class="resume-product-image__image"  :src="product.image_url"></div>
          <div class="resume-product__name">
            <b>(x{{ product.amount }})</b>
            {{ product.name }}
          </Div>
          <div class="resume-product__total">$ {{ product.amount * product.price }}</div>
        </div>
      </div>
      <div class="resume__actions">
        <div class="resume-actions__info">
          Subtotal<br/>
          $ {{ totalPrice }}<br/>
        </div>
        <div class="btn" @click="buy">
          Comprar
        </div>
      </div>
    </div>
  </div>
  </transition>
</template>
<script>
  import { mapState, mapGetters, mapActions } from 'vuex';

  export default {
    data: function () {
      return {}
    },
    computed: {
      ...mapState([
        'showResume'
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
