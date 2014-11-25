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

ActiveRecord::Schema.define(version: 20141119145705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "authors", force: true do |t|
    t.string   "name"
    t.string   "tagline"
    t.string   "twitter"
    t.string   "facebook"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "badges", force: true do |t|
    t.integer  "user_id"
    t.integer  "specialty_id"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges", ["specialty_id"], name: "index_badges_on_specialty_id", using: :btree
  add_index "badges", ["user_id", "created_at"], name: "index_badges_on_user_id_and_created_at", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "hidden",           default: false
    t.integer  "root_id"
    t.string   "root_type"
    t.boolean  "accepted"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["root_id", "root_type"], name: "index_comments_on_root_id_and_root_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "title"
    t.datetime "date"
    t.decimal  "price"
    t.text     "description"
    t.string   "event_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exams", force: true do |t|
    t.integer  "user_id"
    t.integer  "specialty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "percentage",   default: 0
  end

  add_index "exams", ["specialty_id"], name: "index_exams_on_specialty_id", using: :btree
  add_index "exams", ["user_id"], name: "index_exams_on_user_id", using: :btree

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

  create_table "newsletters", force: true do |t|
    t.string   "subject"
    t.text     "body_content"
    t.text     "body_text"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "specialty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.integer  "category_id"
  end

  add_index "notes", ["category_id"], name: "index_notes_on_category_id", using: :btree
  add_index "notes", ["noteable_id", "noteable_type"], name: "index_notes_on_noteable_id_and_noteable_type", using: :btree
  add_index "notes", ["specialty_id"], name: "index_notes_on_specialty_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_image_file_name"
    t.string   "title_image_content_type"
    t.integer  "title_image_file_size"
    t.datetime "title_image_updated_at"
    t.string   "slug"
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "description"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
  end

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
    t.boolean  "proofread",      default: false
    t.integer  "specialty_id"
  end

  add_index "questions", ["specialty_id"], name: "index_questions_on_specialty_id", using: :btree
  add_index "questions", ["video_id"], name: "index_questions_on_video_id", using: :btree

  create_table "sales", force: true do |t|
    t.string   "email"
    t.string   "guid"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.date     "card_expiration"
    t.text     "error"
    t.integer  "fee_amount"
    t.integer  "amount"
    t.integer  "user_id"
  end

  add_index "sales", ["product_id"], name: "index_sales_on_product_id", using: :btree
  add_index "sales", ["user_id"], name: "index_sales_on_user_id", using: :btree

  create_table "specialties", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "professor"
  end

  add_index "specialties", ["category_id"], name: "index_specialties_on_category_id", using: :btree
  add_index "specialties", ["name"], name: "index_specialties_on_name", unique: true, using: :btree
  add_index "specialties", ["slug"], name: "index_specialties_on_slug", unique: true, using: :btree

  create_table "specialty_questions", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "specialty_id"
  end

  add_index "specialty_questions", ["specialty_id"], name: "index_specialty_questions_on_specialty_id", using: :btree
  add_index "specialty_questions", ["user_id"], name: "index_specialty_questions_on_user_id", using: :btree

  create_table "stripe_events", force: true do |t|
    t.string   "stripe_id"
    t.string   "stripe_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["video_id"], name: "index_taggings_on_video_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unlocked_specialties", force: true do |t|
    t.integer  "user_id"
    t.integer  "specialty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unlocked_specialties", ["specialty_id"], name: "index_unlocked_specialties_on_specialty_id", using: :btree
  add_index "unlocked_specialties", ["user_id"], name: "index_unlocked_specialties_on_user_id", using: :btree

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
    t.boolean  "admin",                              default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "points",                             default: 0
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "website"
    t.boolean  "selected_plan",                      default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "login_count",                        default: 0
    t.datetime "last_login_at"
    t.datetime "subscribed_on"
    t.boolean  "receive_newsletters",                default: true
    t.boolean  "receive_new_episode_notifications",  default: true
    t.boolean  "receive_social_notifications",       default: true
    t.string   "unsubscribe_token"
    t.boolean  "receive_status_updates",             default: true
    t.boolean  "avatar_processing"
    t.datetime "expires_on"
    t.boolean  "receive_help_request_notifications", default: true
    t.boolean  "reminder_email_received",            default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "specialty_id"
    t.string   "vimeo_identifier"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "preview",              default: false
    t.string   "slug"
    t.string   "speaker_name"
    t.integer  "views",                default: 0
    t.string   "file_name"
    t.integer  "questions_count",      default: 0,     null: false
    t.integer  "position"
    t.integer  "author_id"
    t.integer  "slide_download_count"
    t.integer  "audio_download_count"
    t.integer  "video_download_count"
    t.boolean  "proofread",            default: false
    t.boolean  "has_slides",           default: true
  end

  add_index "videos", ["author_id"], name: "index_videos_on_author_id", using: :btree
  add_index "videos", ["slug"], name: "index_videos_on_slug", unique: true, using: :btree
  add_index "videos", ["specialty_id"], name: "index_videos_on_specialty_id", using: :btree

  create_table "vimeos", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.decimal  "progress",   default: 0.0
    t.boolean  "completed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vimeos", ["completed"], name: "index_vimeos_on_completed", using: :btree
  add_index "vimeos", ["user_id"], name: "index_vimeos_on_user_id", using: :btree
  add_index "vimeos", ["video_id"], name: "index_vimeos_on_video_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["comment_id"], name: "index_votes_on_comment_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

end
