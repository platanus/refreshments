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
          <select
            v-model="message"
            v-if="showNameTextBox"
            @change="getSelectedUser($event)"
          >
            <option
              disabled
              value=""
            >
              Usuario de Slack
            </option>
            <option
              v-for="user in slackUsers.slack"
              :value="user"
              :key="user"
            >
              {{ user.displayNameNormalized }}
            </option>
          </select>
          <button
            type="button"
            class="btn"
            v-if="showNameTextBox"
            :disabled="confirmDebtButtonDisabled"
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
const CLOSE_MODAL_AFTER_IDLE_WAIT = 7000;

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
      slackUsers: {},
      selectedUser: {},
      confirmDebtButtonDisabled: true,
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
      this.confirmDebtButtonDisabled = true;
      this.showDebtButton = true;
      this.showApologyText = true;
      this.showDebtFinalMessage = false;
      this.showCartOnDebtModal = false;
      this.showNameTextBox = false;
      invoiceApi.notifyPaymentError();
      this.message = '';
    },
    debtorNameInput() {
      this.showCartOnDebtModal = true;
      this.showDebtButton = false;
      this.showNameTextBox = true;
      this.showApologyText = false;
    },
    getSelectedUser(event) {
      this.selectedUser = event.target.value;
      if (event) this.confirmDebtButtonDisabled = false;
    },
    confirmDebtButton() {
      this.showCartOnDebtModal = false;
      this.showNameTextBox = false;
      this.showDebtFinalMessage = true;
      const products = this.cartProductsToReqFormat();
      const debtor = this.message.displayNameNormalized;
      invoiceApi.createDebtProduct({
        'debtor': debtor,
        'products': products,
      });
      const cart = this.products.filter(product => product.amount > 0);
      if (cart) {
        this.notifySellersOfDebt(cart);
      }
      setTimeout(() => {
        this.$modal.hide('apology-modal');
      }, CLOSE_MODAL_AFTER_IDLE_WAIT);
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
    getUsers() {
      return invoiceApi.getSlackUsers();
    },
    notifySellersOfDebt(products) {
      const debtor = this.message.displayNameNormalized;
      const message = `${debtor} acaba de fiar un producto tuyo!`;
      products.forEach(prod => {
        invoiceApi.seller(prod).then((seller) => {
          const messageToDebtor = `${debtor}, acabas de fiar un producto de ${seller.user.name}`;
          invoiceApi.notifyUser(this.message.id, messageToDebtor);
          if (seller.user.slackUser) {
            invoiceApi.notifyUser(seller.user.slackUser, message);
          }
        });
      });
    },
  },
  mounted() {
    this.getUsers().then((slackUsers) => {
      this.slackUsers = slackUsers;
    });
    setTimeout(() => {
      this.showApologyButton = true;
    }, SHOW_APOLOGY_BUTTON);
  },
};
</script>
