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
  product(productId) {
    return axios.get(`/api/v1/products/${productId}`)
      .then((response) => response.data);
  },
  buy(products) {
    return axios.post('/api/v1/invoices', { invoice: { products } })
      .then((response) => response.data);
  },
  checkInvoiceStatus(hash) {
    return axios.get(`/api/v1/invoices/status/${encodeURIComponent(hash)}`)
      .then((response) => response);
  },
  getGif() {
    return axios.get('/api/v1/gif')
      .then((response) => response.data);
  },
};
