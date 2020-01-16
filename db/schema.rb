# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_14_192253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "debt_products", force: :cascade do |t|
    t.string "debtor"
    t.bigint "product_id"
    t.integer "product_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_products", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_price", null: false
    t.bigint "product_id"
    t.integer "product_fee", default: 0, null: false
    t.decimal "fee_rate", default: "0.0", null: false
    t.boolean "dispensed", default: false
    t.index ["invoice_id"], name: "index_invoice_products_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_products_on_product_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "amount", null: false
    t.integer "clp"
    t.string "payment_request"
    t.string "r_hash"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "settled", default: false
  end

  create_table "ledger_accounts", force: :cascade do |t|
    t.string "category"
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.integer "balance", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accountable_type", "accountable_id"], name: "index_ledger_accounts_on_accountable_type_and_accountable_id"
  end

  create_table "ledger_lines", force: :cascade do |t|
    t.bigint "ledger_account_id"
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.datetime "date"
    t.integer "amount"
    t.integer "balance", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["accountable_type", "accountable_id"], name: "index_ledger_lines_on_accountable_type_and_accountable_id"
    t.index ["ledger_account_id"], name: "index_ledger_lines_on_ledger_account_id"
  end

  create_table "lightning_network_withdrawals", force: :cascade do |t|
    t.string "invoice_hash", null: false
    t.string "state"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount"
    t.string "memo"
    t.index ["user_id"], name: "index_lightning_network_withdrawals_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "price", null: false
    t.integer "stock", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "category", default: 2, null: false
    t.decimal "fee_rate", default: "0.0", null: false
    t.string "webhook_url"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "withdrawals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount"
    t.string "aasm_state"
    t.string "btc_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

  add_foreign_key "ledger_lines", "ledger_accounts"
end
