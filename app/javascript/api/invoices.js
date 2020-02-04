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
    const path = '/api/v1/debt_products';

    return api({
      method: 'put',
      url: path,
      data: { debtProduct: { debtor, products } },
    });
  },

  getSlackUsers() {
    const path = 'api/v1/slack';

    return api({
      method: 'get',
      url: path,
    });
  },
  notifyUser(userName, userId, message) {
    const path = 'api/v1/slack';

    return api({
      method: 'post',
      url: path,
      data: { userName, userId, message },
    });
  },
  getSeller(product) {
    const path = `api/v1/products/${product.id}/get_seller`;

    return api({
      method: 'get',
      url: path,
    });
  },
};
