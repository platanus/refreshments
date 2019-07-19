## Accounts

### User

* `counts: available_funds` --> Plata ganada y por lo tanto disponible para retirar
* `counts: unconfirmed_withdrawal_funds` --> Plata en proceso de retiro

### Wallet

* `counts: available_funds` --> Plata que actualmente hay en la billetera (Ej: Nodo LN)


## Money Paths

### Invoice Product - settled

Cuando se paga (settled) un invoice, explicamos la entrada de plata al nodo, como un aumento de la deuda que tenemos hacia el usuario que vendió su producto.

* From: `User.available_funds`
* To: `Wallet.available_funds`
* Through: `InvoiceProduct`
* Category: `settled`

### Lightning Network Withdrawal Payment - new

Cada retiro de LN, independiente de si tuvo éxito o fracaso, descuenta saldo del disponible del usuario (para evitar dobles retiros) y lo mantiene en una cuenta temporal.

* From: `User.unconfirmed_withdrawal_funds`
* To: `User.available_funds`
* Through: `LightningNetworkWithdrawalPayment`
* Category: `new`


### Lightning Network Withdrawal Payment - failed

Cuando el retiro falla, se devuelve el saldo de la cuenta temporal

* From: `User.available_funds`
* To: `User.unconfirmed_withdrawal_funds`
* Through: `LightningNetworkWithdrawalPayment`
* Category: `failed`

### Lightning Network Withdrawal Payment - confirmed

Cuando el retiro se confirma, se descuenta la plata del nodo pagando el saldo de la cuenta temporal

* From: `Wallet.available_funds`
* To: `User.unconfirmed_withdrawal_funds`
* Through: `LightningNetworkWithdrawalPayment`
* Category: `confirmed`

### Withdrawal Payment - confirmed

Retiros antiguos por Bitcoin onchain

* From: `Wallet.available_funds`
* To: `User.available_funds`
* Through: `WithdrawalPayment`
* Category: `confirmed`