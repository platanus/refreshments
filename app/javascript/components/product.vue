<template>
  <v-touch
    class="product-category__product"
    @tap="incrementProduct(product)"
  >
    <img
      class="product__image"
      :src="product.image_url"
    >
    <span class="product__price">${{ product.price }}</span>
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
    this.unsubscribe = this.$store.subscribe((mutation) => {
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
  },
  computed: {
    ...mapState([
      'actionMessage',
      'actionProductId',
    ]),
  },
  beforeDestroy() {
    this.unsubscribe();
  },
};
</script>
