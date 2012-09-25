# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110601042627) do

  create_table "charts", :force => true do |t|
    t.integer  "trade_calculation_id"
    t.string   "range"
    t.string   "chart_type"
    t.string   "size"
    t.text     "moving_averages"
    t.text     "exponential_moving_averages"
    t.text     "indicators"
    t.text     "chart_overlays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charts", ["trade_calculation_id"], :name => "index_charts_on_trade_calculation_id"

  create_table "members", :force => true do |t|
    t.string   "name"
    t.float    "trading_capital"
    t.integer  "risk_percentage"
    t.string   "login"
    t.string   "email"
    t.string   "salt"
    t.string   "crypted_password"
    t.datetime "remember_token_expires_at"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["login"], :name => "index_members_on_login"

  create_table "trade_calculations", :force => true do |t|
    t.integer  "member_id"
    t.string   "name"
    t.text     "description"
    t.integer  "units"
    t.float    "purchase_price"
    t.float    "stop_loss_exit_price"
    t.float    "target_sale_price"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "symbol"
  end

  add_index "trade_calculations", ["member_id"], :name => "index_trade_calculations_on_member_id"

  create_table "trade_logs", :force => true do |t|
    t.integer  "trade_calculation_id"
    t.date     "date"
    t.string   "action"
    t.integer  "units"
    t.float    "price"
    t.float    "total"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trade_logs", ["trade_calculation_id"], :name => "index_trade_logs_on_trade_calculation_id"

end
