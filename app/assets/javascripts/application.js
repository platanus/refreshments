// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require rails-ujs
// = require jquery3
// = require popper
// = require turbolinks
// = require bootstrap
// = require_tree .

/* eslint-env jquery */
/* eslint-env browser */

$(document).ready(() => {
  const imageInput = $('.product-form__input--image');
  const imageLabel = $('.product-form__label--image');
  if (imageInput && imageLabel) {
    imageInput.change(event => {
      imageLabel.text(event.target.value.split('\\').pop());
    });
  }
});

function setFeeValue() {
  const feeValue = $('#result');
  feeValue.text(
    // eslint-disable-next-line no-magic-numbers
    ($('#price').val() * $('#fee').val() / 100).toFixed(1)
  );
}

$(document).on('turbolinks:load', () => {
  setFeeValue();
  $('#price, #fee').change(() => {
    setFeeValue();
  });
});
