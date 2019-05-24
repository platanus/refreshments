export default {
  contentMessage(action, product) {
    let title = 'Agregado';
    let amount = product.amount + 1;

    if (action === 'decrement') {
      title = 'Removido';
      amount -= 2;
    }

    if (action === 'maxStock') {
      title = 'Stock máximo';
      amount -= 1;
    }

    return amount >= 0 ? `${title} ${product.name} <b>(${amount})</b>` : '';
  },
};
