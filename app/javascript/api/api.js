import axios from 'axios';
import * as humps from 'humps';

function api(options) {
  const CSRFToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  if (options.data) {
    options.data = humps.decamelizeKeys(options.data);
  }

  return axios({
    ...options,
    headers: {
      'X-CSRF-Token': CSRFToken,
      ...options.headers,
    },
  }).then(response => humps.camelizeKeys(response.data));
}

export default api;
