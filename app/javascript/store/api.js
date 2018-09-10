import axios from 'axios';

export default {
  products() {
    return axios.get('/api/v1/products')
      .then((response) => response.data);
  },
};
