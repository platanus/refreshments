import api from './api';

export default {
  buy(products) {
    const path = '/api/v1/invoices';

    return api({
      method: 'post',
      url: path,
      data: { invoice: { products } },
    });
  },

  checkInvoiceStatus(hash) {
    const path = `/api/v1/invoices/status/${encodeURIComponent(hash)}`;

    return api({
      method: 'get',
      url: path,
    });
  },

  getGif() {
    const path = '/api/v1/gif';

    return api({
      method: 'get',
      url: path,
    });
  },

  notifyPaymentError() {
    const path = '/api/v1/notify_payment_error';

    return api({
      method: 'get',
      url: path,
    });
  },

  createDebtProduct({ debtor, products }) {
    const path = '/api/v1/create_debt_product'

    return api({
      method: 'post',
      url: path,
      data: { debt_product: { debtor, products } },
    });
  },
};
