import axios from 'axios';

function api(options) {
  const CSRFToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  return axios({
    ...options,
    headers: {
      'X-CSRF-Token': CSRFToken,
      ...options.headers,
    },
  }).then(response => response.data);
}

export default api;
