import axios from 'axios';

axios.defaults.headers = {
  'Content-Type': 'application/json',
  'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
};

export default {
  products() {
    return axios.get('/api/v1/products')
      .then((response) => response.data);
  },
  buy(products, description) {
    return axios.post('/api/v1/invoices', { invoice: { products, memo: description } })
      .then((response) => response.data);
  },
  checkInvoiceStatus(hash) {
    return axios.get(`/api/v1/invoices/status/${encodeURIComponent(hash)}`)
      .then((response) => response);
  },
};
