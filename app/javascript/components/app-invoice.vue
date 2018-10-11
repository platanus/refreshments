<template>
  <transition name="fade">
    <div class="invoice">
      <div class="invoice__resume">
        <h3 class="invoice__title">Resumen</h3>
        {{ invoice.satoshis || 0 }} Satoshis<br/>
        ${{ invoice.clp || 0 }} CLP
      </div>
      <div class="invoice__info" v-if="invoice.payment_request">
        <qrcode :value="invoice.payment_request" :options="{ size: 125 }"></qrcode>
        <div class="btn btn--hash" @click="copyPaymentRequest">
          <font-awesome-icon icon="clipboard" />
          {{ invoice.payment_request }}
        </div>
      </div>
    </div>
  </transition>
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
        'invoice'
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
        'testInvoice'
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
    },
    mounted() {
      this.interval = setInterval(function() {
        if (this.invoice.id && !this.status) {
          this.updateInvoiceSettled();
        } else if (this.invoice.paid) {
          clearInterval(this.interval);
        }
      }.bind(this), 1000);
    }
  }
</script>
