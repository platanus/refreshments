<template>
  <div class="invoice">
    <div class="invoice__resume">
      <h3 class="invoice__title">
        Resumen
      </h3>
      <div
        class="invoice__price"
        :class="{ 'invoice__price--loading': loading}"
      >
        {{ invoice.amount || 0 }} Satoshis
      </div>
      <div
        class="invoice__price"
        :class="{ 'invoice__price--loading': loading}"
      >
        ${{ invoice.clp || 0 }} CLP
      </div>
      <h3 class="invoice__title">
        Recaudado
      </h3>
      <div
        class="invoice__price"
        :class="{ 'invoice__price--loading': loading}"
      >
        ${{ totalFee.clp }} CLP
      </div>
      <div
        class="invoice__price"
        :class="{ 'invoice__price--loading': loading}"
      >
        {{ totalFee.sat }} Satoshis
      </div>
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

    <div class="invoice__info">
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
            v-if="totalPrice > 0"
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
    </div>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex';
import loading from './loading.vue';

const LENOVO_TAB_4_WIDTH = 1000;
const CLOSE_AFTER_SUCCESSFUL_BUY_WAIT = 10000;

export default {
  components: {
    loading,
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
    this.interval = setInterval(function() {
      if (this.invoice.id && !this.status) {
        this.updateInvoiceSettled();
      } else if (this.invoice.paid) {
        clearInterval(this.interval);
      }
    }.bind(this), 1000);
  },
  watch: {
    status: 'reset'
  }
}
</script>
