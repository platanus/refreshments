<template>
  <transition name="fade">
    <div class="invoice" v-if="invoice.id">
      <div class="invoice__container">
        <div class="resume__close" @click="close">
          <font-awesome-icon far icon="times"></font-awesome-icon>
        </div>
        <b>{{ invoice.satoshis }} satoshis</b><br/>
        <b>$ {{ invoice.clp }}</b><br/>
        <div class="invoice__info" v-if="invoice.payment_request">
          <qrcode :value="invoice.payment_request" :options="{ size: 200 }"></qrcode>
          <h3 class="invoice__status" :class="{ 'invoice__status--paid': status }">{{ statusVerbose }}</h3>
        </div>

<!--         <div class="btn" @click="testInvoice">
          Pagar
        </div> -->
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
