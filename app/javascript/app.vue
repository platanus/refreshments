<template>
  <div>
    <div class="header">
      <img class="header__logo" src="~/assets/images/platanus_logo.svg">
    </div>
    <div class="app">
      <h2>Productos</h2>
      <div v-for="product in products">
        {{ product.name }}
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    data: function () {
      return {}
    },
    computed: {
      ...mapState([
        'products'
      ])
    },
    mounted() {
      this.$store.dispatch('getProducts');
    }
  }
</script>
