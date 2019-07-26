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
        <span class="product-category__title">Snacks</span>
        <div
          class="product-category"
          key="snacks"
        >
          <product
            v-for="product in snacks"
            :key="product.id"
            :product="product"
          />
        </div>
        <span class="product-category__title">Bebestibles</span>
        <div
          class="product-category"
          key="drinks"
        >
          <product
            v-for="product in drinks"
            :key="product.id"
            :product="product"
          />
        </div>
        <span class="product-category__title">Otros</span>
        <div
          class="product-category"
          key="other"
        >
          <product
            v-for="product in other"
            :key="product.id"
            :product="product"
          />
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
  components: {
    appResume,
    appInvoice,
    product,
    feedback,
  },
  computed: {
    ...mapGetters({
      'snacks': 'groupBySnack',
      'drinks': 'groupByDrink',
      'other': 'groupByOther',
    }),
    ...mapState([
      'status',
    ]),
  },
  methods: {
    closeModal() {
      this.$store.commit('setStatus', false);
    },
  },
  mounted() {
    this.$store.dispatch('getProducts');
  },
};
</script>
