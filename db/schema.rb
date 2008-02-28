# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 37) do

  create_table "attachments", :force => true do |t|
    t.integer "content_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"

  create_table "blogs", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "allow_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_properties", :force => true do |t|
    t.integer  "card_id"
    t.integer  "property_id"
    t.integer  "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_types", :force => true do |t|
    t.string   "card_id"
    t.string   "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.string   "title"
    t.text     "description",  :limit => 255
    t.integer  "project_id"
    t.integer  "iteration_id"
    t.integer  "team_id"
    t.float    "estimated"
    t.float    "actual"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "content_versions", :force => true do |t|
    t.integer  "content_id"
    t.integer  "version"
    t.integer  "status_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "keywords"
    t.text     "text"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "allow_comments"
    t.boolean  "is_think_box"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
  end

  create_table "contents", :force => true do |t|
    t.integer  "status_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "keywords"
    t.text     "text"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "allow_comments"
    t.boolean  "is_think_box"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
    t.boolean  "published"
    t.datetime "published_at"
  end

  create_table "departments", :force => true do |t|
    t.integer  "content_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iterations", :force => true do |t|
    t.date     "started_at"
    t.date     "ended_at"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "members", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", :force => true do |t|
    t.string   "name"
    t.integer  "property_id"
    t.integer  "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deprecated"
  end

  create_table "posts", :force => true do |t|
    t.integer  "blog_id"
    t.integer  "user_id"
    t.integer  "status_id"
    t.string   "permalink"
    t.boolean  "allow_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "scope_id"
    t.string   "scope_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_option"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "count"
  end

  create_table "teams", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "types", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "department_id"
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.string   "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "google_number"
    t.integer  "default_page"
    t.integer  "password_reset_code"
  end

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
