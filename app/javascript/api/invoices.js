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
};
