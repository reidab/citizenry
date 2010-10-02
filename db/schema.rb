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

ActiveRecord::Schema.define(:version => 20100926044756) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "twitter"
    t.text     "address"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies_projects", :id => false, :force => true do |t|
    t.integer  "company_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employments", :force => true do |t|
    t.integer  "person_id"
    t.integer  "company_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "person_id"
    t.string   "membership_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "mailing_list"
    t.string   "twitter"
    t.text     "meeting_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_projects", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "twitter"
    t.string   "url"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "people_projects", :id => false, :force => true do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "twitter"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsorships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "company_id"
    t.string   "sponsorship_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "twitter_id"
    t.string   "login"
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "location"
    t.string   "description"
    t.string   "profile_image_url"
    t.string   "url"
    t.boolean  "protected"
    t.string   "profile_background_color"
    t.string   "profile_sidebar_fill_color"
    t.string   "profile_link_color"
    t.string   "profile_sidebar_border_color"
    t.string   "profile_text_color"
    t.string   "profile_background_image_url"
    t.boolean  "profile_background_tile"
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.integer  "followers_count"
    t.integer  "favourites_count"
    t.integer  "utc_offset"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
