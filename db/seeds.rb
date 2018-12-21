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

new_admin = AdminUser.create!(email: "admin@example.com", password: "123456")

3.times do |i|
  new_user = User.create!(
    name: "example_name_#{i}",
    email: "user_#{i}@example.com",
    password: "123456",
  )
  4.times do |j|
    new_product = Product.create!(
      name: "example_name_#{i}_#{j}",
      active: true,
      price: 500,
      user: new_user,
    )
    5.times do |k|
      new_invoice = Invoice.create!(
        satoshis: 1000,
        clp: 500,
        payment_request: "MyString_#{i}_#{j}_#{k}",
        r_hash: "MyString_#{i}_#{j}_#{k}",
        memo: "MyString_#{i}_#{j}_#{k}",
        settled: false,
      )
      new_invoice.invoice_products.create!(product: new_product)
    end
  end
end

