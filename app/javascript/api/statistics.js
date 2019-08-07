import api from './api';

export default {
  feeBalance() {
    const path = '/api/v1/statistics/fee_balance';

    return api({
      method: 'get',
      url: path,
    });
  },
};
