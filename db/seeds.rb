# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Write the code in a way that can be executed multiple times without duplicating the information.
#
# For example:
#
# Country.create(name: "Chile") # BAD
# Country.find_or_create_by(name: "Chile") # GOOD
#

new_admin = AdminUser.create(email: "admin@example.com", password: "123456")

new_user = User.create(name: "example_name", email: "user@example.com", password: "123456")

new_product = Product.create(
  name: "Coca-cola",
  active: true,
  price: 500,
  user: new_user,
)

new_invoice = Invoice.create(
  satoshis: 1000,
  clp: 500,
  payment_request: "MyString",
  r_hash: "MyString",
  memo: "MyString",
  settled: false,
)

new_product_invoice = InvoiceProduct.create(product: new_product, invoice: new_invoice)
