<template>
  <div class="app-header">
    <img class="app-header__logo" src="~/assets/images/platanus_logo.svg">
    <div class="app-header__basket">
      <font-awesome-layers class="fa-fw fa-2x" @click="toggleResume">
        <font-awesome-icon far icon="shopping-basket"></font-awesome-icon>
        <font-awesome-layers class="fa-layers-counter fa-layers-top-right">{{ totalAmount }}</font-awesome-layers>
      </font-awesome-layers>
    </div>
  </div>
</template>
<script>
  import { mapGetters, mapActions } from 'vuex';

  export default {
    data: function () {
      return {}
    },
    computed: {
      ...mapGetters([
        'totalAmount',
      ]),
    },
    methods: {
      ...mapActions([
        'toggleResume',
      ])
    }
  }
</script>
