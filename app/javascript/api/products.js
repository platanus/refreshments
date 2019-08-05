import api from './api';

export default {
  products() {
    const path = '/api/v1/products';

    return api({
      method: 'get',
      url: path,
    });
  },

  product(productId) {
    const path = `/api/v1/products/${productId}`;

    return api({
      method: 'get',
      url: path,
    });
  },
};
