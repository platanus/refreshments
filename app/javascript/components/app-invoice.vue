<template>
  <div class="invoice">
    <errorNotification v-if="totalPrice" />
    <div
      class="invoice__info"
      v-if="totalPrice > 0"
    >
      <loading v-if="loading" />
      <transition
        name="slide-fade"
        v-else
      >
        <div
          v-if="!status"
          key="unpaid"
        >
          <qrcode
            :value="invoice.paymentRequest"
            :options="{ size: 160 }"
            v-if="totalPrice > 0 && typeof invoice.paymentRequest !== 'undefined'"
          />
        </div>
        <div
          v-else
          key="slide-fade"
          class="invoice-info--paid"
        >
          <font-awesome-icon icon="check-circle" />
          Pagado!
        </div>
      </transition>
      <div
        class="invoice__copy"
        @click="copyPaymentRequest"
        v-if="showCopy"
      >
        <div class="invoice__copy-value">
          {{ invoice.paymentRequest }}
        </div>
        <span class="invoice__copy-icon">
          <font-awesome-icon icon="clipboard" />
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex';
import loading from './loading.vue';
import errorNotification from './payment-error-button.vue';

const LENOVO_TAB_4_WIDTH = 1000;
const CLOSE_AFTER_SUCCESSFUL_BUY_WAIT = 10000;
const CLEAN_INVOICE_TIME = 3000;

export default {
  components: {
    loading,
    errorNotification,
  },
  data: function () {
    return {}
  },
  computed: {
    ...mapState([
      'status',
      'invoice',
      'loading',
    ]),
    ...mapGetters({
      'totalPrice': 'totalPrice',
      'totalFee': 'totalFee',
    }),
    statusVerbose() {
      return this.status ? '¡Pagado!' : 'Esperando pago...';
    },
    showCopy() {
      const isTablet = /(android)/i.test(navigator.userAgent) && screen.width > LENOVO_TAB_4_WIDTH;

      return (this.invoice.paymentRequest && !isTablet);
    },
  },
  channels: {
    InvoicesChannel: {
      connected() { console.log('connected to invoice channel'); },
      received(data) {
        if (data) {
          this.updateInvoiceSettled();
        }
      },
    },
  },
  methods: {
    ...mapActions([
      'toggleResume',
      'cleanCart',
      'cleanInvoice',
      'updateInvoiceSettled',
      'getFeeBalance',
    ]),
    close() {
      this.cleanInvoice();
      this.cleanCart();
      this.toggleResume();
      this.getFeeBalance();
    },
    copyPaymentRequest() {
      this.$copyText(this.invoice.paymentRequest).then(e => {
        console.log(e)
      }, e => {
        console.log(e)
      })
    },
    reset() {
      if (this.status) {
        setTimeout(() => {
          this.close();
        }, CLOSE_AFTER_SUCCESSFUL_BUY_WAIT);
      }
    },
  },
  mounted() {
    this.$cable.subscribe({
      channel: 'InvoicesChannel',
    });
  },
  watch: {
    status: 'reset'
  }
}
</script>
