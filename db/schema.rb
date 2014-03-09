# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 0) do

  create_table "category", force: true do |t|
    t.string  "name",   limit: 2048, null: false
    t.integer "parent",              null: false
  end

  create_table "challenge", primary_key: "cha_id", force: true do |t|
    t.string   "username",    limit: 500, null: false
    t.integer  "runid",                   null: false
    t.integer  "data_type",               null: false
    t.text     "data_detail",             null: false
    t.integer  "data_lang",               null: false
    t.string   "cha_result",  limit: 500, null: false
    t.text     "cha_detail",              null: false
    t.datetime "cha_time",                null: false
    t.integer  "cid",                     null: false
  end

  add_index "challenge", ["cha_time"], name: "cha_time", using: :btree
  add_index "challenge", ["cid"], name: "cid", using: :btree
  add_index "challenge", ["username"], name: "username", length: {"username"=>255}, using: :btree

  create_table "config", force: true do |t|
    t.string "name",  limit: 1024, null: false
    t.string "value", limit: 2048, null: false
  end

  create_table "contest", primary_key: "cid", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "isprivate",            limit: 2,        null: false
    t.datetime "start_time",                            null: false
    t.datetime "end_time",                              null: false
    t.datetime "lock_board_time",                       null: false
    t.boolean  "hide_others",                           null: false
    t.datetime "board_make",                            null: false
    t.integer  "isvirtual",            limit: 2,        null: false
    t.string   "owner",                                 null: false
    t.text     "report",               limit: 16777215, null: false
    t.datetime "mboard_make",                           null: false
    t.string   "allp",                 limit: 1000,     null: false
    t.integer  "type",                                  null: false
    t.boolean  "has_cha",                               null: false
    t.datetime "challenge_end_time",                    null: false
    t.datetime "challenge_start_time",                  null: false
    t.string   "password",             limit: 2048,     null: false
  end

  add_index "contest", ["allp"], name: "allp", length: {"allp"=>255}, using: :btree
  add_index "contest", ["end_time"], name: "end_time", using: :btree
  add_index "contest", ["isprivate"], name: "isprivate", using: :btree
  add_index "contest", ["lock_board_time"], name: "lock_board_time", using: :btree
  add_index "contest", ["start_time"], name: "start_time", using: :btree

  create_table "contest_clarify", primary_key: "ccid", force: true do |t|
    t.integer "cid",      null: false
    t.text    "question", null: false
    t.text    "reply",    null: false
    t.string  "username", null: false
    t.boolean "ispublic", null: false
  end

  add_index "contest_clarify", ["cid"], name: "cid", using: :btree
  add_index "contest_clarify", ["username"], name: "username", using: :btree

  create_table "contest_problem", primary_key: "cpid", force: true do |t|
    t.integer "cid",               null: false
    t.integer "pid",               null: false
    t.string  "lable",  limit: 20, null: false
    t.integer "type",              null: false
    t.integer "base",              null: false
    t.integer "minp",              null: false
    t.float   "para_a",            null: false
    t.float   "para_b",            null: false
    t.float   "para_c",            null: false
    t.float   "para_d",            null: false
    t.float   "para_e",            null: false
    t.float   "para_f",            null: false
  end

  add_index "contest_problem", ["cid"], name: "cid", using: :btree

  create_table "contest_user", primary_key: "cuid", force: true do |t|
    t.integer "cid",      null: false
    t.string  "username", null: false
  end

  add_index "contest_user", ["cid"], name: "cid", using: :btree
  add_index "contest_user", ["cuid"], name: "cuid", using: :btree

  create_table "discuss", force: true do |t|
    t.integer  "fid",     null: false
    t.integer  "rid",     null: false
    t.datetime "time",    null: false
    t.string   "title",   null: false
    t.text     "content", null: false
    t.string   "uname",   null: false
    t.integer  "pid",     null: false
  end

  create_table "language_name", force: true do |t|
    t.string "name", null: false
  end

  create_table "mail", primary_key: "mailid", force: true do |t|
    t.string   "sender",    null: false
    t.string   "reciever",  null: false
    t.text     "title",     null: false
    t.text     "content",   null: false
    t.datetime "mail_time", null: false
    t.boolean  "status",    null: false
  end

  add_index "mail", ["mail_time"], name: "mail_time", using: :btree
  add_index "mail", ["reciever"], name: "reciever", using: :btree
  add_index "mail", ["sender"], name: "sender", using: :btree

  create_table "news", primary_key: "newsid", force: true do |t|
    t.datetime "time_added",              null: false
    t.string   "title",      limit: 1024
    t.text     "content"
    t.string   "author"
  end

  create_table "ojinfo", force: true do |t|
    t.string   "name",                   null: false
    t.string   "int64io",                null: false
    t.string   "javaclass",              null: false
    t.string   "status",    limit: 1024, null: false
    t.datetime "lastcheck",              null: false
  end

  add_index "ojinfo", ["name"], name: "name", unique: true, using: :btree

  create_table "problem", primary_key: "pid", force: true do |t|
    t.string  "title",                                               null: false
    t.text    "description",          limit: 2147483647,             null: false
    t.text    "input",                                               null: false
    t.text    "output",                                              null: false
    t.text    "sample_in",                                           null: false
    t.text    "sample_out",                                          null: false
    t.integer "number_of_testcase",                                  null: false
    t.integer "total_submit",                                        null: false
    t.integer "total_ac",                                            null: false
    t.integer "total_wa",                                            null: false
    t.integer "total_re",                                            null: false
    t.integer "total_ce",                                            null: false
    t.integer "total_tle",                                           null: false
    t.integer "total_mle",                                           null: false
    t.integer "total_pe",                                            null: false
    t.integer "total_ole",                                           null: false
    t.integer "total_rf",                                            null: false
    t.integer "special_judge_status", limit: 2,          default: 0, null: false
    t.integer "basic_solver_value",                                  null: false
    t.integer "ac_value",                                            null: false
    t.integer "time_limit",                                          null: false
    t.integer "case_time_limit",                                     null: false
    t.integer "memory_limit",                            default: 0, null: false
    t.text    "hint",                                                null: false
    t.string  "source",               limit: 1024,                   null: false
    t.text    "author",                                              null: false
    t.boolean "hide",                                                null: false
    t.string  "vid",                  limit: 50,                     null: false
    t.string  "vname",                limit: 50,                     null: false
    t.boolean "isvirtual",                                           null: false
    t.integer "vacnum",                                              null: false
    t.integer "vtotalnum",                                           null: false
    t.boolean "ignore_noc",                                          null: false
    t.integer "vacpnum",                                             null: false
    t.integer "vtotalpnum",                                          null: false
  end

  add_index "problem", ["hide"], name: "hide", using: :btree
  add_index "problem", ["isvirtual"], name: "isvirtual", using: :btree
  add_index "problem", ["source"], name: "source", length: {"source"=>255}, using: :btree
  add_index "problem", ["title"], name: "title", using: :btree
  add_index "problem", ["vid"], name: "vid", using: :btree
  add_index "problem", ["vname"], name: "vname", using: :btree

  create_table "problem_category", primary_key: "pcid", force: true do |t|
    t.integer "pid",    null: false
    t.integer "catid",  null: false
    t.integer "weight", null: false
  end

  add_index "problem_category", ["catid"], name: "catid", using: :btree
  add_index "problem_category", ["pid"], name: "pid", using: :btree

  create_table "ranklist", id: false, force: true do |t|
    t.integer "uid",                       default: 0, null: false
    t.string  "username"
    t.string  "nickname",     limit: 1024
    t.integer "local_ac",                              null: false
    t.integer "total_ac",                              null: false
    t.integer "total_submit",                          null: false
  end

  create_table "replay_status", primary_key: "runid", force: true do |t|
    t.integer  "pid",                         null: false
    t.string   "result",         limit: 100
    t.datetime "time_submit"
    t.integer  "contest_belong",              null: false
    t.string   "username",       limit: 1024
  end

  add_index "replay_status", ["contest_belong"], name: "contest_belong", using: :btree
  add_index "replay_status", ["pid"], name: "pid", using: :btree
  add_index "replay_status", ["result"], name: "result", using: :btree
  add_index "replay_status", ["time_submit"], name: "time_submit", using: :btree
  add_index "replay_status", ["username"], name: "username", length: {"username"=>255}, using: :btree

  create_table "status", primary_key: "runid", force: true do |t|
    t.integer  "pid",                             null: false
    t.string   "result",         limit: 100
    t.integer  "memory_used"
    t.integer  "time_used"
    t.datetime "time_submit"
    t.integer  "contest_belong",                  null: false
    t.string   "username"
    t.text     "source",         limit: 16777215
    t.integer  "language",                        null: false
    t.text     "ce_info"
    t.string   "ipaddr"
    t.boolean  "isshared",                        null: false
    t.integer  "jnum",           limit: 2,        null: false
  end

  add_index "status", ["contest_belong"], name: "contest_belong", using: :btree
  add_index "status", ["isshared"], name: "isshared", using: :btree
  add_index "status", ["language"], name: "language", using: :btree
  add_index "status", ["pid"], name: "pid", using: :btree
  add_index "status", ["result"], name: "result", using: :btree
  add_index "status", ["time_submit"], name: "time_submit", using: :btree
  add_index "status", ["username"], name: "username", using: :btree

  create_table "time_bbs", id: false, force: true do |t|
    t.integer  "rid",  null: false
    t.datetime "time", null: false
    t.integer  "pid",  null: false
  end

  create_table "user", primary_key: "uid", force: true do |t|
    t.string   "username"
    t.string   "nickname",        limit: 1024
    t.string   "password",        limit: 50,                   null: false
    t.string   "email"
    t.string   "school"
    t.integer  "total_submit",                                 null: false
    t.integer  "total_ac",                                     null: false
    t.datetime "register_time",                                null: false
    t.datetime "last_login_time",                              null: false
    t.string   "photo"
    t.integer  "total_value",                                  null: false
    t.boolean  "lock_status",                  default: false, null: false
    t.integer  "isroot",                                       null: false
    t.string   "ipaddr"
    t.integer  "local_ac",                                     null: false
  end

  add_index "user", ["nickname"], name: "nickname", length: {"nickname"=>255}, using: :btree
  add_index "user", ["password"], name: "password", using: :btree
  add_index "user", ["username"], name: "username", using: :btree

  create_table "usertag", force: true do |t|
    t.integer "pid",                   null: false
    t.string  "username", limit: 2048, null: false
    t.integer "catid",                 null: false
  end

  add_index "usertag", ["catid"], name: "catid", using: :btree
  add_index "usertag", ["pid"], name: "pid", using: :btree
  add_index "usertag", ["username"], name: "username", length: {"username"=>255}, using: :btree

  create_table "vurl", force: true do |t|
    t.string "voj", limit: 50,   null: false
    t.string "vid", limit: 50,   null: false
    t.string "url", limit: 2048, null: false
  end

  add_index "vurl", ["voj", "vid"], name: "voj", using: :btree

end
