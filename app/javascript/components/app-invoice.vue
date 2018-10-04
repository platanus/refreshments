<template>
  <transition name="fade">
    <div class="invoice" v-if="invoice.id">
      <div class="invoice__container">
        <div class="invoice__close" @click="close">
          <font-awesome-icon far icon="times"></font-awesome-icon>
        </div>
        <div class="invoice__resume">
          <b>Envía {{ invoice.satoshis }} satoshis ($ {{ invoice.clp }})</b><br/>
          <b>escaneando el QR</b><br/>
          <span class="invoice__resume__emoji">👇</span>
        </div>
        <div class="invoice__info" v-if="invoice.payment_request">
          <qrcode :value="invoice.payment_request" :options="{ size: 250 }"></qrcode>
          <div class="btn btn--hash" @click="copyPaymentRequest">{{ invoice.payment_request }}</div>
          <h3 class="invoice__status" :class="{ 'invoice__status--paid': status }">{{ statusVerbose }}</h3>
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
