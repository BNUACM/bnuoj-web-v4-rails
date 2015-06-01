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

ActiveRecord::Schema.define(version: 20150218060735) do

  create_table "category", force: :cascade do |t|
    t.string  "name",   limit: 2048, null: false
    t.integer "parent", limit: 4,    null: false
  end

  create_table "challenge", primary_key: "cha_id", force: :cascade do |t|
    t.string   "username",    limit: 500,   null: false
    t.integer  "runid",       limit: 4,     null: false
    t.integer  "data_type",   limit: 4,     null: false
    t.text     "data_detail", limit: 65535, null: false
    t.integer  "data_lang",   limit: 4,     null: false
    t.string   "cha_result",  limit: 500,   null: false
    t.text     "cha_detail",  limit: 65535, null: false
    t.datetime "cha_time",                  null: false
    t.integer  "cid",         limit: 4,     null: false
  end

  add_index "challenge", ["cha_time"], name: "cha_time", using: :btree
  add_index "challenge", ["cid"], name: "cid", using: :btree
  add_index "challenge", ["username"], name: "username", length: {"username"=>333}, using: :btree

  create_table "config", primary_key: "lable", force: :cascade do |t|
    t.string "substitle", limit: 4096, null: false
  end

  create_table "contest", primary_key: "cid", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.text     "description",          limit: 65535
    t.boolean  "isprivate",            limit: 1,        null: false
    t.datetime "start_time",                            null: false
    t.datetime "end_time",                              null: false
    t.datetime "lock_board_time",                       null: false
    t.boolean  "hide_others",          limit: 1,        null: false
    t.datetime "board_make",                            null: false
    t.integer  "isvirtual",            limit: 2,        null: false
    t.string   "owner",                limit: 255,      null: false
    t.text     "report",               limit: 16777215, null: false
    t.datetime "mboard_make",                           null: false
    t.string   "allp",                 limit: 1000,     null: false
    t.integer  "type",                 limit: 4,        null: false
    t.boolean  "has_cha",              limit: 1,        null: false
    t.datetime "challenge_end_time",                    null: false
    t.datetime "challenge_start_time",                  null: false
    t.string   "password",             limit: 2048,     null: false
    t.boolean  "owner_viewable",       limit: 1,        null: false
  end

  add_index "contest", ["allp"], name: "allp", length: {"allp"=>333}, using: :btree
  add_index "contest", ["end_time"], name: "end_time", using: :btree
  add_index "contest", ["isprivate"], name: "isprivate", using: :btree
  add_index "contest", ["lock_board_time"], name: "lock_board_time", using: :btree
  add_index "contest", ["start_time"], name: "start_time", using: :btree

  create_table "contest_clarify", primary_key: "ccid", force: :cascade do |t|
    t.integer "cid",      limit: 4,     null: false
    t.text    "question", limit: 65535, null: false
    t.text    "reply",    limit: 65535, null: false
    t.string  "username", limit: 255,   null: false
    t.boolean "ispublic", limit: 1,     null: false
  end

  add_index "contest_clarify", ["cid"], name: "cid", using: :btree
  add_index "contest_clarify", ["username"], name: "username", using: :btree

  create_table "contest_problem", primary_key: "cpid", force: :cascade do |t|
    t.integer "cid",    limit: 4,  null: false
    t.integer "pid",    limit: 4,  null: false
    t.string  "lable",  limit: 20, null: false
    t.integer "type",   limit: 4,  null: false
    t.integer "base",   limit: 4,  null: false
    t.integer "minp",   limit: 4,  null: false
    t.float   "para_a", limit: 53, null: false
    t.float   "para_b", limit: 53, null: false
    t.float   "para_c", limit: 53, null: false
    t.float   "para_d", limit: 53, null: false
    t.float   "para_e", limit: 53, null: false
    t.float   "para_f", limit: 53, null: false
  end

  add_index "contest_problem", ["cid"], name: "cid", using: :btree

  create_table "contest_user", primary_key: "cuid", force: :cascade do |t|
    t.integer "cid",      limit: 4,   null: false
    t.string  "username", limit: 255, null: false
  end

  add_index "contest_user", ["cid"], name: "cid", using: :btree
  add_index "contest_user", ["cuid"], name: "cuid", using: :btree

  create_table "discuss", force: :cascade do |t|
    t.integer  "fid",     limit: 4,     null: false
    t.integer  "rid",     limit: 4,     null: false
    t.datetime "time",                  null: false
    t.string   "title",   limit: 255,   null: false
    t.text     "content", limit: 65535, null: false
    t.string   "uname",   limit: 255,   null: false
    t.integer  "pid",     limit: 4,     null: false
  end

  create_table "language_name", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "mail", primary_key: "mailid", force: :cascade do |t|
    t.string   "sender",    limit: 255,   null: false
    t.string   "reciever",  limit: 255,   null: false
    t.text     "title",     limit: 65535, null: false
    t.text     "content",   limit: 65535, null: false
    t.datetime "mail_time",               null: false
    t.boolean  "status",    limit: 1,     null: false
  end

  add_index "mail", ["mail_time"], name: "mail_time", using: :btree
  add_index "mail", ["reciever"], name: "reciever", using: :btree
  add_index "mail", ["sender"], name: "sender", using: :btree

  create_table "news", primary_key: "newsid", force: :cascade do |t|
    t.datetime "time_added",               null: false
    t.string   "title",      limit: 1024
    t.text     "content",    limit: 65535
    t.string   "author",     limit: 255
  end

  create_table "ojinfo", force: :cascade do |t|
    t.string   "name",      limit: 255,  null: false
    t.string   "int64io",   limit: 255,  null: false
    t.string   "javaclass", limit: 255,  null: false
    t.string   "status",    limit: 1024, null: false
    t.datetime "lastcheck",              null: false
  end

  add_index "ojinfo", ["name"], name: "name", unique: true, using: :btree

  create_table "privileges", force: :cascade do |t|
    t.integer  "user_id",           limit: 4,   null: false
    t.string   "privilege",         limit: 255, null: false
    t.string   "restrict_to_key",   limit: 255, null: false
    t.string   "restrict_to_value", limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "privileges", ["user_id", "privilege", "restrict_to_key", "restrict_to_value"], name: "user_priv", unique: true, using: :btree

  create_table "problem", primary_key: "pid", force: :cascade do |t|
    t.string  "title",                limit: 255,                    null: false
    t.text    "description",          limit: 4294967295,             null: false
    t.text    "input",                limit: 65535,                  null: false
    t.text    "output",               limit: 65535,                  null: false
    t.text    "sample_in",            limit: 65535,                  null: false
    t.text    "sample_out",           limit: 65535,                  null: false
    t.integer "number_of_testcase",   limit: 4,                      null: false
    t.integer "total_submit",         limit: 4,                      null: false
    t.integer "total_ac",             limit: 4,                      null: false
    t.integer "total_wa",             limit: 4,                      null: false
    t.integer "total_re",             limit: 4,                      null: false
    t.integer "total_ce",             limit: 4,                      null: false
    t.integer "total_tle",            limit: 4,                      null: false
    t.integer "total_mle",            limit: 4,                      null: false
    t.integer "total_pe",             limit: 4,                      null: false
    t.integer "total_ole",            limit: 4,                      null: false
    t.integer "total_rf",             limit: 4,                      null: false
    t.integer "special_judge_status", limit: 2,          default: 0, null: false
    t.integer "basic_solver_value",   limit: 4,                      null: false
    t.integer "ac_value",             limit: 4,                      null: false
    t.integer "time_limit",           limit: 4,                      null: false
    t.integer "case_time_limit",      limit: 4,                      null: false
    t.integer "memory_limit",         limit: 4,          default: 0, null: false
    t.text    "hint",                 limit: 65535,                  null: false
    t.text    "source",               limit: 65535,                  null: false
    t.text    "author",               limit: 65535,                  null: false
    t.boolean "hide",                 limit: 1,                      null: false
    t.string  "vid",                  limit: 50,                     null: false
    t.string  "vname",                limit: 50,                     null: false
    t.boolean "isvirtual",            limit: 1,                      null: false
    t.integer "vacnum",               limit: 4,                      null: false
    t.integer "vtotalnum",            limit: 4,                      null: false
    t.boolean "ignore_noc",           limit: 1,                      null: false
    t.integer "vacpnum",              limit: 4,                      null: false
    t.integer "vtotalpnum",           limit: 4,                      null: false
    t.boolean "is_interactive",       limit: 1,                      null: false
  end

  add_index "problem", ["hide"], name: "hide", using: :btree
  add_index "problem", ["isvirtual"], name: "isvirtual", using: :btree
  add_index "problem", ["source"], name: "source", length: {"source" => 333}, using: :btree
  add_index "problem", ["title"], name: "title", using: :btree
  add_index "problem", ["vid"], name: "vid", using: :btree
  add_index "problem", ["vname"], name: "vname", using: :btree

  create_table "problem_category", primary_key: "pcid", force: :cascade do |t|
    t.integer "pid",    limit: 4, null: false
    t.integer "catid",  limit: 4, null: false
    t.integer "weight", limit: 4, null: false
  end

  add_index "problem_category", ["catid"], name: "catid", using: :btree
  add_index "problem_category", ["pid"], name: "pid", using: :btree

  create_table "ranklist", id: false, force: :cascade do |t|
    t.integer "uid",          limit: 4,    default: 0, null: false
    t.string  "username",     limit: 255
    t.string  "nickname",     limit: 1024
    t.integer "local_ac",     limit: 4,                null: false
    t.integer "total_ac",     limit: 4,                null: false
    t.integer "total_submit", limit: 4,                null: false
  end

  create_table "replay_status", primary_key: "runid", force: :cascade do |t|
    t.integer  "pid",            limit: 4,    null: false
    t.string   "result",         limit: 100
    t.datetime "time_submit"
    t.integer  "contest_belong", limit: 4,    null: false
    t.string   "username",       limit: 1024
  end

  add_index "replay_status", ["contest_belong"], name: "contest_belong", using: :btree
  add_index "replay_status", ["pid"], name: "pid", using: :btree
  add_index "replay_status", ["result"], name: "result", using: :btree
  add_index "replay_status", ["time_submit"], name: "time_submit", using: :btree
  add_index "replay_status", ["username"], name: "username", length: {"username"=>333}, using: :btree

  create_table "solver", primary_key: "solverid", force: :cascade do |t|
    t.integer "pid",      limit: 4,    null: false
    t.integer "value",    limit: 4,    null: false
    t.string  "filename", limit: 1024, null: false
    t.string  "owner",    limit: 255,  null: false
  end

  create_table "solverlist", id: false, force: :cascade do |t|
    t.integer "uid",      limit: 4, null: false
    t.integer "solverid", limit: 4, null: false
  end

  create_table "status", primary_key: "runid", force: :cascade do |t|
    t.integer  "pid",            limit: 4,        null: false
    t.string   "result",         limit: 100
    t.integer  "memory_used",    limit: 4
    t.integer  "time_used",      limit: 4
    t.datetime "time_submit"
    t.integer  "contest_belong", limit: 4,        null: false
    t.string   "username",       limit: 255
    t.text     "source",         limit: 16777215
    t.integer  "language",       limit: 4,        null: false
    t.text     "ce_info",        limit: 65535
    t.string   "ipaddr",         limit: 255
    t.boolean  "isshared",       limit: 1,        null: false
    t.integer  "jnum",           limit: 2,        null: false
  end

  add_index "status", ["contest_belong"], name: "contest_belong", using: :btree
  add_index "status", ["isshared"], name: "isshared", using: :btree
  add_index "status", ["language"], name: "language", using: :btree
  add_index "status", ["pid"], name: "pid", using: :btree
  add_index "status", ["result"], name: "result", using: :btree
  add_index "status", ["time_submit"], name: "time_submit", using: :btree
  add_index "status", ["username"], name: "username", using: :btree

  create_table "time_bbs", id: false, force: :cascade do |t|
    t.integer  "rid",  limit: 4, null: false
    t.datetime "time",           null: false
    t.integer  "pid",  limit: 4, null: false
  end

  create_table "user", primary_key: "uid", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "nickname",        limit: 1024
    t.string   "password",        limit: 50,                   null: false
    t.string   "email",           limit: 255
    t.string   "school",          limit: 255
    t.integer  "total_submit",    limit: 4,                    null: false
    t.integer  "total_ac",        limit: 4,                    null: false
    t.datetime "register_time",                                null: false
    t.datetime "last_login_time",                              null: false
    t.string   "photo",           limit: 255
    t.integer  "total_value",     limit: 4,                    null: false
    t.boolean  "lock_status",     limit: 1,    default: false, null: false
    t.integer  "isroot",          limit: 4,                    null: false
    t.string   "ipaddr",          limit: 255
    t.integer  "local_ac",        limit: 4,                    null: false
  end

  add_index "user", ["nickname"], name: "nickname", length: {"nickname"=>333}, using: :btree
  add_index "user", ["password"], name: "password", using: :btree
  add_index "user", ["username"], name: "username", using: :btree

  create_table "usertag", force: :cascade do |t|
    t.integer "pid",      limit: 4,    null: false
    t.string  "username", limit: 2048, null: false
    t.integer "catid",    limit: 4,    null: false
  end

  add_index "usertag", ["catid"], name: "catid", using: :btree
  add_index "usertag", ["pid"], name: "pid", using: :btree
  add_index "usertag", ["username"], name: "username", length: {"username"=>333}, using: :btree

  create_table "vurl", force: :cascade do |t|
    t.string "voj", limit: 50,   null: false
    t.string "vid", limit: 50,   null: false
    t.string "url", limit: 2048, null: false
  end

  add_index "vurl", ["voj", "vid"], name: "voj", using: :btree

end
