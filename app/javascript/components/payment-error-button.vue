<template>
  <div class="payment-error-button">
    <modal name="apology-modal">
      <div class="invoice__apology-modal-text">
        <h1>Error en el pago</h1>
        Disculpe las molestias :(, lo vamos a revisar para que puedas pagar en el futuro
      </div>
      <div
        class="invoice__apology-modal-debtn"
      >
        <button
          type="button"
          class="btn"
        >
          Fiar
        </button>
      </div>
    </modal>
    <div class="invoice__error-btn ">
      <button
        type="button"
        v-if="showApologyButton"
        class="btn"
        @click="show"
      >
        ¿No funciona?
      </button>
    </div>
  </div>
</template>

<script>

import invoiceApi from '../api/invoices';

const SHOW_APOLOGY_BUTTON = 10000;
const CLOSE_MODAL_AFTER_IDLE_WAIT = 7000;

export default {
  data() {
    return {
      showApologyButton: false,
    };
  },
  methods: {
    show() {
      this.$modal.show('apology-modal');
      invoiceApi.notifyPaymentError();
      setTimeout(() => {
        this.$modal.hide('apology-modal');
      }, CLOSE_MODAL_AFTER_IDLE_WAIT);
    },
  },
  mounted() {
    setTimeout(() => {
      this.showApologyButton = true;
    }, SHOW_APOLOGY_BUTTON);
  },
};
</script>
