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

ActiveRecord::Schema.define(version: 20140310131238) do

  create_table "favorites", force: true do |t|
    t.string  "name"
    t.string  "user"
    t.boolean "is_public"
    t.string  "plugin"
    t.text    "options"
  end

  add_index "favorites", ["name"], name: "index_favorites_on_name"
  add_index "favorites", ["user"], name: "index_favorites_on_user"

  create_table "keywords", force: true do |t|
    t.string  "keyword"
    t.integer "favorite_id"
  end

  add_index "keywords", ["favorite_id"], name: "index_keywords_on_favorite_id"
  add_index "keywords", ["keyword"], name: "index_keywords_on_keyword"

end
