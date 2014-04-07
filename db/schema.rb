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

ActiveRecord::Schema.define(version: 20140407103444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: true do |t|
    t.integer  "user_id"
    t.integer  "specialty_id"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges", ["user_id", "created_at"], name: "index_badges_on_user_id_and_created_at", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "hidden",           default: false
    t.integer  "video_id"
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.datetime "date"
    t.decimal  "price"
    t.text     "description"
    t.string   "event_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "member_only", default: false
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "questions", force: true do |t|
    t.text     "stem"
    t.string   "answer_1"
    t.string   "answer_2"
    t.string   "answer_3"
    t.string   "answer_4"
    t.string   "answer_5"
    t.integer  "correct_answer"
    t.text     "explanation"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["video_id"], name: "index_questions_on_video_id", using: :btree

  create_table "specialties", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "specialties", ["category_id"], name: "index_specialties_on_category_id", using: :btree
  add_index "specialties", ["slug"], name: "index_specialties_on_slug", unique: true, using: :btree

  create_table "user_questions", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.boolean  "correct_answer", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_questions", ["question_id"], name: "index_user_questions_on_question_id", using: :btree
  add_index "user_questions", ["user_id"], name: "index_user_questions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",            default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "points",           default: 0
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "specialty_id"
    t.string   "vimeo_identifier"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "preview",          default: false
    t.string   "slug"
    t.string   "speaker_name"
    t.integer  "views",            default: 0
    t.string   "file_name"
    t.integer  "questions_count",  default: 0,     null: false
  end

  add_index "videos", ["slug"], name: "index_videos_on_slug", unique: true, using: :btree
  add_index "videos", ["specialty_id"], name: "index_videos_on_specialty_id", using: :btree

end
