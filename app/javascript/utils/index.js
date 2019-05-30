export default {
  contentMessage(action, product) {
    let title = 'Agregado';
    let amount = product.amount + 1;
    let status = 'success';

    if (action === 'decrement') {
      title = 'Removido';
      amount -= 2;
    } else if (action === 'maxStock') {
      title = 'Stock máximo';
      amount -= 1;
      status = 'error';
    }

    return { message: amount >= 0 ? `${title} ${product.name} <b>(${amount})</b>` : '',
      status };
  },
};
