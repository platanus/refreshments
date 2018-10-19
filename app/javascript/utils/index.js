export default {
  contentMessage(action, product) {
    let title = 'Agregado';
    let amount = product.amount + 1;

    if (action === 'decrement') {
      title = 'Removido';
      amount -= 2;
    }

    return amount >= 0 ? `${title} ${product.name} <b>(${amount})</b>` : '';
  },
};
