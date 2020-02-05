<template>
  <div>
    <feedback
      v-show="status"
      @close="closeModal"
    />
    <div class="messages">
      <flash-message transition-name="list-complete" />
    </div>
    <div class="app">
      <div class="product-categories">
        <div
          v-for="category in productsArray"
          :key="category.title"
        >
          <span class="product-category__title">{{ category.title }}</span>
          <div class="product-category">
            <product
              v-for="product in category.products"
              :key="product.id"
              :product="product"
            />
          </div>
        </div>
      </div>
      <div class="sidebar">
        <div class="sidebar__container">
          <app-resume />
          <app-invoice />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex';

import appResume from './components/app-resume.vue';
import appInvoice from './components/app-invoice.vue';
import product from './components/product.vue';
import feedback from './components/feedback.vue';

export default {
  data() {
    return {
      inactiveTime: null,
      refreshTime: 300000,
    };
  },
  components: {
    appResume,
    appInvoice,
    product,
    feedback,
  },
  computed: {
    ...mapGetters({
      'products': 'groupByCategory',
    }),
    ...mapState([
      'status',
    ]),
    productsArray() {
      return [
        { title: 'Snacks', products: this.products('snacks') },
        { title: 'Bebestibles', products: this.products('drinks') },
        { title: 'Otros', products: this.products('other') },
      ];
    },
  },
  channels: {
    ProductsChannel: {
      connected() { console.log('connected'); },
      received(data) {
        if (data) {
          console.log(data);
          console.log(data.product);
          this.productsArray.push(data.product);
        }
      },
    },
  },
  methods: {
    closeModal() {
      this.$store.commit('setStatus', false);
    },
    checkInactivity() {
      clearTimeout(this.inactiveTime);
      this.inactiveTime = setTimeout(() => {
        this.$store.dispatch('refreshProducts');
        this.refreshScrollBar();
      }, this.refreshTime);
    },
    refreshScrollBar() {
      const categories = [...this.$el.querySelectorAll('.product-category')];
      categories.forEach(category => {
        category.scrollLeft = 0;
      });
    },
  },
  mounted() {
    this.$cable.subscribe({
      channel: 'ProductsChannel',
    });
    this.$store.dispatch('getProducts');
    this.$store.dispatch('getFeeBalance');
    ['click', 'mousedown', 'touchmove'].forEach(
      event => this.$el.addEventListener(event, this.checkInactivity),
    );
  },
};
</script>
