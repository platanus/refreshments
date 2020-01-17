<template>
  <div class="payment-error-button">
    <modal name="apology-modal">
      <div class="invoice__apology-modal-flexbox">
        <div class="invoice__apology-modal-text">
          <div
            class="invoice__apology-modal-text-first"
            v-if="showApologyText"
          >
            <h5> Error en el pago </h5>
            Disculpe las molestias :(, lo vamos a revisar para que puedas pagar en el futuro
          </div>
          <div
            class="invoice__apology-modal-text-second"
            v-if="showCartOnDebtModal"
          >
            <h5> Productos </h5>
            <cartProducts />
          </div>
          <div v-if="showDebtFinalMessage">
            <h5> Listo! </h5>
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
          >
            Confirmar
          </button>
        </div>
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
const CLOSE_MODAL_AFTER_IDLE_WAIT = 20000;

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
      message: '',
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
      const products = this.cartProductsToReqFormat();
      invoiceApi.createDebtProduct({
        'debtor': this.message,
        'products': products,
      });
    },
    cartProductsToReqFormat() {
      const productsArray = this.products.filter(product => product.amount > 0);
      const productsToReqFormatArray = [];
      productsArray.forEach(prod => {
        productsToReqFormatArray.push(
          { 'product_id': prod.id, 'product_price': prod.price, 'product_amount': prod.amount });
      });

      return productsToReqFormatArray;
    },
  },
  mounted() {
    setTimeout(() => {
      this.showApologyButton = true;
    }, SHOW_APOLOGY_BUTTON);
  },
};
</script>
