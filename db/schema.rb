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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140629074145) do

  create_table "audiobank_projects", :force => true do |t|
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contents", :force => true do |t|
    t.string   "type",             :null => false
    t.string   "name",             :null => false
    t.string   "slug",             :null => false
    t.integer  "duration"
    t.integer  "episode_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "audiobank_cast"
    t.string   "url"
    t.boolean  "principal"
    t.datetime "available_end_at"
    t.integer  "audiobank_id"
  end

  add_index "contents", ["audiobank_cast"], :name => "index_contents_on_audiobank_cast"
  add_index "contents", ["audiobank_id"], :name => "index_contents_on_audiobank_id"

  create_table "episodes", :force => true do |t|
    t.integer  "order"
    t.string   "title",                                                             :null => false
    t.string   "slug",                                                              :null => false
    t.text     "description",    :limit => 16777215
    t.integer  "show_id",                                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
    t.datetime "broadcasted_at"
    t.integer  "rating_count"
    t.decimal  "rating_total",                       :precision => 10, :scale => 0
    t.decimal  "rating_avg",                         :precision => 10, :scale => 2
  end

  create_table "ftp_accounts", :force => true do |t|
    t.string   "userid"
    t.string   "passwd"
    t.integer  "uid"
    t.integer  "guid"
    t.string   "homedir"
    t.string   "shell"
    t.integer  "template_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ftp_groups", :force => true do |t|
    t.string  "groupname"
    t.integer "gid"
    t.string  "members"
  end

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.integer  "site_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "google_analytics_tracker_id"
    t.string   "site_type"
  end

  create_table "images", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "db_file_id"
    t.integer  "show_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_uid"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "position"
    t.integer  "show_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "show_id"
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "radio_shows", :force => true do |t|
    t.string   "slug"
    t.integer  "radio_id"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "radios", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "template_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "radios_shows", :id => false, :force => true do |t|
    t.integer "radio_id", :null => false
    t.integer "show_id",  :null => false
  end

  create_table "radios_users", :id => false, :force => true do |t|
    t.integer "radio_id", :null => false
    t.integer "user_id",  :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer "rated_id"
    t.string  "rated_type"
    t.decimal "rating",     :precision => 10, :scale => 0
  end

  add_index "ratings", ["rated_type", "rated_id"], :name => "index_ratings_on_rated_type_and_rated_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.text     "description",          :limit => 16777215
    t.string   "slug",                                     :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "logo_id"
    t.integer  "visit_count",                              :default => 0,  :null => false
    t.string   "podcast_comment"
    t.integer  "template_id"
    t.integer  "audiobank_project_id"
  end

  create_table "shows_users", :id => false, :force => true do |t|
    t.integer "show_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "scm_url"
  end

  create_table "templates_users", :id => false, :force => true do |t|
    t.integer "template_id", :null => false
    t.integer "user_id",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

end
