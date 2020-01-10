<template>
  <div class="payment-error-button">
    <modal name="apology-modal">
      <div class="invoice__apology-modal-text">
        <div v-if="showApologyText">
          <h1> Error en el pago </h1>
          Disculpe las molestias :(, lo vamos a revisar para que puedas pagar en el futuro
        </div>
        <div v-if="showCartOnDebtModal">
          <h1> Productos </h1>
          <cartProducts/>
        </div>
        <div v-if="showDebtFinalMessage">
          <h1> Listo! </h1>
          Recuerda pagarle al vendedor cuando puedas :)
        </div>
      </div>
      <div
        class="invoice__apology-modal-debtn"
      >
        <button
          type="button"
          class="btn"
          v-if="showDebtButton"
          @click="debtorNameInput"
        >
          Fiar
        </button>
        <input
          v-model="message"
          placeholder="Tu Nombre"
          v-if="showNameTextBox"
        >
        <button
          type="button"
          class="btn"
          v-if="showNameTextBox"
          @click="confirmDebtButton"
        > Confirmar
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

import { mapGetters } from 'vuex';
import invoiceApi from '../api/invoices';
import cartProducts from './cart-products.vue';

const SHOW_APOLOGY_BUTTON = 10000;
const CLOSE_MODAL_AFTER_IDLE_WAIT = 10000;

export default {
  components: {
    cartProducts,
  },
  data() {
    return {
      showCartOnDebtModal: false,
      showApologyButton: false,
      showDebtButton: false,
      showNameTextBox: false,
      showApologyText: true,
      showDebtFinalMessage: false,
    };
  },
  computed: {
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
  methods: {
    show() {
      this.$modal.show('apology-modal');
      this.showDebtButton = true;
      this.showApologyText = true;
      this.showDebtFinalMessage = false;
      this.showCartOnDebtModal = false;
      this.showNameTextBox = false;
      invoiceApi.notifyPaymentError();
      setTimeout(() => {
        this.$modal.hide('apology-modal');
      }, CLOSE_MODAL_AFTER_IDLE_WAIT);
    },
    debtorNameInput() {
      this.showCartOnDebtModal = true;
      this.showDebtButton = false;
      this.showNameTextBox = true;
      this.showApologyText = false;
    },
    confirmDebtButton() {
      this.showCartOnDebtModal = false;
      this.showNameTextBox = false;
      this.showDebtFinalMessage = true;
    },
  },
  mounted() {
    setTimeout(() => {
      this.showApologyButton = true;
    }, SHOW_APOLOGY_BUTTON);
  },
};
</script>
