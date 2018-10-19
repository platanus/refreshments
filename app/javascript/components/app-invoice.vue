<template>
  <div class="invoice">
    <div class="invoice__resume">
      <h3 class="invoice__title">Resumen</h3>
      {{ invoice.satoshis || 0 }} Satoshis<br/>
      ${{ invoice.clp || 0 }} CLP
      <div class="invoice__copy" @click="copyPaymentRequest" v-if="invoice.payment_request">
        <div class="invoice__copy-value">{{ invoice.payment_request }}</div>
        <span class="invoice__copy-icon">
          <font-awesome-icon icon="clipboard" />
        </span>
      </div>
    </div>
    <div class="invoice__info" v-if="invoice.payment_request">
      <transition name="slide-fade">
        <div class="invoice-info--unpaid" v-if="!status" key="unpaid">
          <qrcode :value="invoice.payment_request" :options="{ size: 160 }"></qrcode>
        </div>
        <div class="invoice-info--paid" v-else key="slide-fade">
          <font-awesome-icon icon="check-circle"/>
          Pagado!
        </div>
      </transition>
    </div>
  </div>
</template>
<script>
  import { mapState, mapActions } from 'vuex';

  export default {
    data: function () {
      return {}
    },
    computed: {
      ...mapState([
        'status',
        'invoice',
        'loading'
      ]),
      statusVerbose() {
        return this.status ? '¡Pagado!' : 'Esperando pago...';
      },
    },
    methods: {
      ...mapActions([
        'toggleResume',
        'cleanKart',
        'cleanInvoice',
        'updateInvoiceSettled',
      ]),
      close() {
        this.cleanInvoice();
        this.cleanKart();
        this.toggleResume();
      },
      copyPaymentRequest() {
        this.$copyText(this.invoice.payment_request).then(e => {
          console.log(e)
        }, e => {
          console.log(e)
        })
      },
      reset() {
        if (this.status) {
          this.flash('<b>Compra Exitosa.</b><br/>Se limpiará el carro para quedar disponible para la siguiente compra.', 'success', { timeout: 5000 });
          setTimeout(() => {
            this.close();
          }, 5000);
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
