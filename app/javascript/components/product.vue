<template>
  <v-touch
    class="product-list__product"
    @tap="incrementProduct(product)"
  >
    <img
      class="product__image"
      :src="product.image_url"
    >
    <span class="product__price">${{ userProductPrice(product) }}</span>
  </v-touch>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import utils from '../utils/';

export default {
  props: {
    product: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {};
  },
  mounted() {
    this.$store.subscribe((mutation) => {
      if (mutation.type === 'setActionMessage' && this.actionProductId === this.product.id) {
        this.message(this.actionMessage, this.product);
      }
    });
  },
  methods: {
    ...mapActions([
      'incrementProduct',
    ]),
    message(action, product) {
      const content = utils.contentMessage(action, product);

      if (content.message.length > 0) {
        this.flash(content.message, content.status);
      }
    },
    userProductPrice(product) {
      const sortedList = [...product.user_products].sort((a, b) => (a.price - b.price));

      return sortedList[0].price;
    },
  },
  computed: {
    ...mapState([
      'actionMessage',
      'actionProductId',
    ]),
  },
};
</script>
