<template>
  <transition name="modal-fade">
    <div
      class="modal-backdrop"
      @click="close"
    >
      <div
        class="feedback-modal"
        role="dialog"
        aria-labelledby="modalTitle"
        aria-describedby="modalDescription"
      >
        <header
          class="feedback-modal__header"
          id="modalTitle"
        >
          <slot name="header">
            Compra exitosa!
          </slot>
        </header>
        <section
          class="feedback-modal__gif"
          id="modalDescription"
        >
          <slot name="gif">
            <img :src="gif">
          </slot>
        </section>
        <section class="feedback-modal__detail">
          Con tu compra aportaste {{ invoice.feeAmount }} SAT para el asado
        </section>
        <section class="feedback-modal__detail feedback-modal__detail--fee-balance">
          Acumulados: {{ updatedFeeBalance }} SAT
        </section>
      </div>
    </div>
  </transition>
</template>

<script>
import { mapActions, mapState } from 'vuex';

const CHEER_AUDIO = '/audios/cheer.wav';

export default {
  computed: {
    ...mapState([
      'gif',
      'status',
      'invoice',
      'feeBalance',
    ]),
    updatedFeeBalance() {
      return this.feeBalance + this.invoice.feeAmount || 0;
    },
  },
  methods: {
    ...mapActions(['getGif']),
    close() {
      this.$emit('close');
    },
    playSound(sound) {
      const audio = new Audio(sound);
      audio.play();
    },
  },
  mounted() {
    this.getGif();
  },
  watch: {
    status(newValue, oldValue) {
      if (oldValue) {
        this.getGif();
      } else if (newValue) {
        this.playSound(CHEER_AUDIO);
      }
    },
  },
};
</script>
